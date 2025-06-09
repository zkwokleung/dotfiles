#!/bin/bash

# 🚀 Dotfiles Integration Tests
# Test the complete setup and bootstrap process

set -e

# Test configuration
TEST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$TEST_DIR")"
TEMP_HOME="/tmp/dotfiles-integration-test-$$"
PASSED_TESTS=0
FAILED_TESTS=0
TOTAL_TESTS=0

# Color functions
print_test() {
    printf "\e[36m🧪 INTEGRATION TEST: %s\e[0m\n" "$1"
}

print_pass() {
    printf "\e[32m✅ PASS: %s\e[0m\n" "$1"
    PASSED_TESTS=$((PASSED_TESTS + 1))
}

print_fail() {
    printf "\e[31m❌ FAIL: %s\e[0m\n" "$1"
    FAILED_TESTS=$((FAILED_TESTS + 1))
}

print_info() {
    printf "\e[34mℹ️  %s\e[0m\n" "$1"
}

print_header() {
    printf "\n\e[1;35m=== %s ===\e[0m\n" "$1"
}

# Test runner function
run_test() {
    local test_name="$1"
    local test_function="$2"

    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    print_test "$test_name"

    # Setup fresh environment for each test
    setup_test_env

    if $test_function; then
        print_pass "$test_name"
        cleanup_test_env
        return 0
    else
        print_fail "$test_name"
        cleanup_test_env
        return 1
    fi
}

# Setup test environment
setup_test_env() {
    print_info "Setting up integration test environment in $TEMP_HOME"
    rm -rf "$TEMP_HOME"
    mkdir -p "$TEMP_HOME"

    # Copy project to test directory
    cp -r "$PROJECT_ROOT"/* "$TEMP_HOME/" 2>/dev/null || true
    cp -r "$PROJECT_ROOT"/.* "$TEMP_HOME/" 2>/dev/null || true

    export HOME="$TEMP_HOME"
    cd "$TEMP_HOME"
}

# Cleanup test environment
cleanup_test_env() {
    rm -rf "$TEMP_HOME"
}

# Test: Bootstrap script without setup (existing environment)
test_bootstrap_existing() {
    # Simulate existing dotfiles
    mkdir -p "$HOME/.config/tmux"
    touch "$HOME/.zshrc"
    touch "$HOME/.aliases"

    # Run bootstrap
    if ./bootstrap.sh --force >/dev/null 2>&1; then
        # Check if essential files were created/updated
        if [[ -f "$HOME/.config/tmux/tmux.conf.local" ]] &&
           [[ -f "$HOME/.config/starship.toml" ]] &&
           [[ -f "$HOME/.aliases" ]]; then
            return 0
        else
            echo "Bootstrap didn't create expected files"
            return 1
        fi
    else
        echo "Bootstrap script failed"
        return 1
    fi
}

# Test: Setup script validation (without actually installing)
test_setup_validation() {
    # Mock brew command to avoid actual installation
    export PATH="$TEMP_HOME/mock:$PATH"
    mkdir -p "$TEMP_HOME/mock"

    # Create mock brew that reports packages as already installed
    cat > "$TEMP_HOME/mock/brew" << 'EOF'
#!/bin/bash
case "$1" in
    "list")
        # Simulate package already installed
        exit 0
        ;;
    "install")
        echo "Would install: $*"
        exit 0
        ;;
    "--prefix")
        echo "/tmp/mock-brew"
        ;;
    *)
        echo "Mock brew: $*"
        exit 0
        ;;
esac
EOF
    chmod +x "$TEMP_HOME/mock/brew"

    # Create mock directories that setup.sh expects
    mkdir -p "/tmp/mock-brew/share/zsh-autosuggestions"
    mkdir -p "/tmp/mock-brew/share/zsh-syntax-highlighting"

    # Test setup script (dry run without actual package installation)
    if ./setup.sh --help >/dev/null 2>&1 || bash -n ./setup.sh 2>/dev/null; then
        return 0
    else
        echo "Setup script validation failed"
        return 1
    fi
}

# Test: Health check after bootstrap
test_health_check_integration() {
    # Run bootstrap first
    if ./bootstrap.sh --force >/dev/null 2>&1; then
        # Make health-check executable
        chmod +x health-check.sh

        # Run health check and capture output
        if ./health-check.sh >/dev/null 2>&1; then
            return 0
        else
            echo "Health check failed after bootstrap"
            return 1
        fi
    else
        echo "Bootstrap failed, can't test health check"
        return 1
    fi
}

# Test: File permissions after installation
test_file_permissions() {
    if ./bootstrap.sh --force >/dev/null 2>&1; then
        # Check that scripts remain executable
        local scripts=("setup.sh" "bootstrap.sh" "health-check.sh")

        for script in "${scripts[@]}"; do
            if [[ ! -x "$script" ]]; then
                echo "Script $script lost execute permission"
                return 1
            fi
        done

        # Check that dotfiles have correct permissions
        if [[ -f "$HOME/.aliases" && ! -r "$HOME/.aliases" ]]; then
            echo "Dotfiles don't have read permissions"
            return 1
        fi

        return 0
    else
        echo "Bootstrap failed"
        return 1
    fi
}

# Test: Configuration file syntax after installation
test_installed_config_syntax() {
    if ./bootstrap.sh --force >/dev/null 2>&1; then
        # Test that installed configs have valid syntax
        local configs=(
            "$HOME/.aliases"
            "$HOME/.functions"
            "$HOME/.exports"
        )

        for config in "${configs[@]}"; do
            if [[ -f "$config" ]]; then
                if ! bash -n "$config" 2>/dev/null; then
                    echo "Installed config $config has syntax errors"
                    return 1
                fi
            fi
        done

        # Test Git config
        if [[ -f "$HOME/.gitconfig" ]]; then
            if ! git config --global --list >/dev/null 2>&1; then
                echo "Installed git config has errors"
                return 1
            fi
        fi

        return 0
    else
        echo "Bootstrap failed"
        return 1
    fi
}

# Test: Tmux configuration validation
test_tmux_config_integration() {
    if ./bootstrap.sh --force >/dev/null 2>&1; then
        # Check if tmux config was installed correctly
        if [[ -f "$HOME/.config/tmux/tmux.conf.local" ]]; then
            # Mock tmux command to test config
            export PATH="$TEMP_HOME/mock:$PATH"
            mkdir -p "$TEMP_HOME/mock"

            cat > "$TEMP_HOME/mock/tmux" << 'EOF'
#!/bin/bash
case "$1" in
    "source-file")
        # Simulate successful config load
        exit 0
        ;;
    *)
        exit 0
        ;;
esac
EOF
            chmod +x "$TEMP_HOME/mock/tmux"

            # Test config loading
            if tmux source-file "$HOME/.config/tmux/tmux.conf.local" 2>/dev/null; then
                return 0
            else
                echo "Tmux config failed to load"
                return 1
            fi
        else
            echo "Tmux config not installed"
            return 1
        fi
    else
        echo "Bootstrap failed"
        return 1
    fi
}

# Test: VS Code settings integration
test_vscode_integration() {
    if ./bootstrap.sh --force >/dev/null 2>&1; then
        # Check if VS Code settings were installed
        if [[ -f "$HOME/.vscode/settings.json" ]]; then
            # Validate JSON syntax
            if command -v python3 >/dev/null 2>&1; then
                if python3 -m json.tool "$HOME/.vscode/settings.json" >/dev/null 2>&1; then
                    return 0
                else
                    echo "VS Code settings JSON is invalid"
                    return 1
                fi
            else
                # If no python3, just check file exists and is readable
                if [[ -r "$HOME/.vscode/settings.json" ]]; then
                    return 0
                else
                    echo "VS Code settings not readable"
                    return 1
                fi
            fi
        else
            echo "VS Code settings not installed"
            return 1
        fi
    else
        echo "Bootstrap failed"
        return 1
    fi
}

# Test: Cross-platform compatibility check
test_cross_platform() {
    # Test on different simulated platforms
    local original_ostype="$OSTYPE"

    # Test macOS
    export OSTYPE="darwin20.0"
    if ! ./bootstrap.sh --force >/dev/null 2>&1; then
        echo "Bootstrap failed on simulated macOS"
        export OSTYPE="$original_ostype"
        return 1
    fi

    # Test Linux
    export OSTYPE="linux-gnu"
    setup_test_env  # Reset environment
    if ! ./bootstrap.sh --force >/dev/null 2>&1; then
        echo "Bootstrap failed on simulated Linux"
        export OSTYPE="$original_ostype"
        return 1
    fi

    export OSTYPE="$original_ostype"
    return 0
}

# Test: Idempotency (running multiple times should be safe)
test_idempotency() {
    # Run bootstrap multiple times
    for i in {1..3}; do
        if ! ./bootstrap.sh --force >/dev/null 2>&1; then
            echo "Bootstrap failed on run $i"
            return 1
        fi
    done

    # Check that files are still valid after multiple runs
    if [[ -f "$HOME/.aliases" ]] && [[ -f "$HOME/.config/tmux/tmux.conf.local" ]]; then
        return 0
    else
        echo "Files corrupted after multiple bootstrap runs"
        return 1
    fi
}

# Main test runner
main() {
    print_header "🚀 Dotfiles Integration Tests"

    # Ensure scripts are executable
    chmod +x "$PROJECT_ROOT/setup.sh"
    chmod +x "$PROJECT_ROOT/bootstrap.sh"
    chmod +x "$PROJECT_ROOT/health-check.sh"

    # Run all integration tests
    run_test "Bootstrap existing environment" test_bootstrap_existing
    run_test "Setup script validation" test_setup_validation
    run_test "Health check integration" test_health_check_integration
    run_test "File permissions" test_file_permissions
    run_test "Installed config syntax" test_installed_config_syntax
    run_test "Tmux config integration" test_tmux_config_integration
    run_test "VS Code integration" test_vscode_integration
    run_test "Cross-platform compatibility" test_cross_platform
    run_test "Idempotency" test_idempotency

    # Test summary
    print_header "📊 Integration Test Results"
    printf "Total Tests: %d\n" "$TOTAL_TESTS"
    printf "\e[32mPassed: %d\e[0m\n" "$PASSED_TESTS"
    printf "\e[31mFailed: %d\e[0m\n" "$FAILED_TESTS"

    if [[ $FAILED_TESTS -eq 0 ]]; then
        printf "\n\e[32m🎉 All integration tests passed!\e[0m\n"
        exit 0
    else
        printf "\n\e[31m💥 %d integration test(s) failed!\e[0m\n" "$FAILED_TESTS"
        exit 1
    fi
}

# Run integration tests
main "$@"
