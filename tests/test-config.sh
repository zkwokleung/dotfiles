#!/bin/bash

# 🧪 Dotfiles Configuration Tests
# Comprehensive test suite for validating configurations

set -e

# Test configuration
TEST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$TEST_DIR")"
TEMP_HOME="/tmp/dotfiles-test-$$"
PASSED_TESTS=0
FAILED_TESTS=0
TOTAL_TESTS=0

# Color functions
print_test() {
    printf "\e[36m🧪 TEST: %s\e[0m\n" "$1"
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

    if $test_function; then
        print_pass "$test_name"
        return 0
    else
        print_fail "$test_name"
        return 1
    fi
}

# Setup test environment
setup_test_env() {
    print_info "Setting up test environment in $TEMP_HOME"
    rm -rf "$TEMP_HOME"
    mkdir -p "$TEMP_HOME"
    export HOME="$TEMP_HOME"
    cd "$PROJECT_ROOT"
}

# Cleanup test environment
cleanup_test_env() {
    print_info "Cleaning up test environment"
    rm -rf "$TEMP_HOME"
}

# Test: Check if required files exist
test_required_files() {
    local required_files=(
        "setup.sh"
        "bootstrap.sh"
        "health-check.sh"
        ".aliases"
        ".functions"
        ".exports"
        ".bash_profile"
        ".zshrc"
        ".gitconfig"
        ".tmux.conf.local"
        ".gitmux.yaml"
        "starship.toml"
        ".editorconfig"
        ".vscode/settings.json"
    )

    for file in "${required_files[@]}"; do
        if [[ ! -f "$file" ]]; then
            echo "Missing required file: $file"
            return 1
        fi
    done

    return 0
}

# Test: Validate shell script syntax
test_shell_syntax() {
    local shell_files=(
        "setup.sh"
        "bootstrap.sh"
        "health-check.sh"
        ".aliases"
        ".functions"
        ".exports"
        ".bash_profile"
        ".bash_prompt"
    )

    for file in "${shell_files[@]}"; do
        if [[ -f "$file" ]]; then
            if ! bash -n "$file" 2>/dev/null; then
                echo "Syntax error in $file"
                return 1
            fi
        fi
    done

    return 0
}

# Test: Validate JSON files
test_json_syntax() {
    local json_files=(
        ".vscode/settings.json"
    )

    for file in "${json_files[@]}"; do
        if [[ -f "$file" ]]; then
            if command -v jq >/dev/null 2>&1; then
                if ! jq empty "$file" 2>/dev/null; then
                    echo "Invalid JSON in $file"
                    return 1
                fi
            elif command -v python3 >/dev/null 2>&1; then
                if ! python3 -m json.tool "$file" >/dev/null 2>&1; then
                    echo "Invalid JSON in $file"
                    return 1
                fi
            fi
        fi
    done

    return 0
}

# Test: Validate YAML files
test_yaml_syntax() {
    local yaml_files=(
        ".gitmux.yaml"
    )

    for file in "${yaml_files[@]}"; do
        if [[ -f "$file" ]]; then
            if command -v yamllint >/dev/null 2>&1; then
                # Check for syntax errors only, ignore warnings
                if ! yamllint -d "{extends: relaxed, rules: {line-length: {max: 120}}}" "$file" 2>/dev/null; then
                    echo "YAML syntax error in $file"
                    return 1
                fi
            elif command -v python3 >/dev/null 2>&1; then
                if ! python3 -c "import yaml; yaml.safe_load(open('$file'))" 2>/dev/null; then
                    echo "YAML syntax error in $file"
                    return 1
                fi
            fi
        fi
    done

    return 0
}

# Test: Validate TOML files
test_toml_syntax() {
    local toml_files=(
        "starship.toml"
    )

    for file in "${toml_files[@]}"; do
        if [[ -f "$file" ]]; then
            if command -v python3 >/dev/null 2>&1; then
                if ! python3 -c "import tomllib; tomllib.load(open('$file', 'rb'))" 2>/dev/null; then
                    # Fallback for older Python versions
                    if ! python3 -c "import toml; toml.load('$file')" 2>/dev/null; then
                        echo "TOML syntax error in $file"
                        return 1
                    fi
                fi
            fi
        fi
    done

    return 0
}

# Test: Check tmux configuration syntax
test_tmux_config() {
    if [[ -f ".tmux.conf.local" ]]; then
        # Check for basic tmux syntax issues
        if grep -q "set -g " ".tmux.conf.local" &&
           grep -q "bind " ".tmux.conf.local"; then
            return 0
        else
            echo "Tmux configuration missing essential commands"
            return 1
        fi
    fi

    return 0
}

# Test: Validate git configuration
test_git_config() {
    if [[ -f ".gitconfig" ]]; then
        # Test git config syntax
        if GIT_CONFIG_GLOBAL=".gitconfig" git config --list >/dev/null 2>&1; then
            return 0
        else
            echo "Git configuration syntax error"
            return 1
        fi
    fi

    return 0
}

# Test: Check for common issues in aliases
test_aliases() {
    if [[ -f ".aliases" ]]; then
        # Check for syntax issues in aliases
        if source ".aliases" 2>/dev/null; then
            return 0
        else
            echo "Aliases file has syntax errors"
            return 1
        fi
    fi

    return 0
}

# Test: Verify setup script dependencies
test_setup_dependencies() {
    if [[ -f "setup.sh" ]]; then
        # Check if required package list exists
        if grep -q "declare -a req" "setup.sh"; then
            return 0
        else
            echo "Setup script missing package declaration"
            return 1
        fi
    fi

    return 0
}

# Test: Check bootstrap script logic
test_bootstrap_logic() {
    if [[ -f "bootstrap.sh" ]]; then
        # Check for essential rsync commands
        if grep -q "rsync.*--exclude" "bootstrap.sh" &&
           grep -q "tmux.*conf" "bootstrap.sh"; then
            return 0
        else
            echo "Bootstrap script missing essential commands"
            return 1
        fi
    fi

    return 0
}

# Test: Validate EditorConfig
test_editorconfig() {
    if [[ -f ".editorconfig" ]]; then
        # Basic validation for EditorConfig syntax
        if grep -q "root = true" ".editorconfig" &&
           grep -q "\[.*\]" ".editorconfig"; then
            return 0
        else
            echo "EditorConfig file malformed"
            return 1
        fi
    fi

    return 0
}

# Test: Health check script validation
test_health_check() {
    if [[ -f "health-check.sh" ]]; then
        # Test if health check can be sourced
        if bash -n "health-check.sh" 2>/dev/null; then
            return 0
        else
            echo "Health check script has syntax errors"
            return 1
        fi
    fi

    return 0
}

# Test: Check for security issues
test_security() {
    local security_issues=0

    # Check for hardcoded passwords or keys (exclude documentation and test files)
    if grep -r -i "password\|secret\|key.*=" . \
        --exclude-dir=.git \
        --exclude-dir=tests \
        --exclude-dir=.github \
        --exclude="*.md" \
        --exclude="*.yml" \
        --exclude="*.yaml" \
        --exclude="run-tests.sh" 2>/dev/null | \
        grep -v "# " | \
        grep -v "example" | \
        grep -v "template" | \
        grep -v "placeholder"; then
        echo "Potential hardcoded secrets found"
        security_issues=$((security_issues + 1))
    fi

    # Check for overly permissive permissions in scripts
    for script in setup.sh bootstrap.sh health-check.sh; do
        if [[ -f "$script" && ! -x "$script" ]]; then
            echo "Script $script is not executable"
            security_issues=$((security_issues + 1))
        fi
    done

    return $security_issues
}

# Main test runner
main() {
    print_header "🧪 Dotfiles Configuration Tests"

    setup_test_env

    # Run all tests
    run_test "Required files exist" test_required_files
    run_test "Shell script syntax" test_shell_syntax
    run_test "JSON file syntax" test_json_syntax
    run_test "YAML file syntax" test_yaml_syntax
    run_test "TOML file syntax" test_toml_syntax
    run_test "Tmux configuration" test_tmux_config
    run_test "Git configuration" test_git_config
    run_test "Aliases validation" test_aliases
    run_test "Setup dependencies" test_setup_dependencies
    run_test "Bootstrap logic" test_bootstrap_logic
    run_test "EditorConfig format" test_editorconfig
    run_test "Health check script" test_health_check
    run_test "Security checks" test_security

    cleanup_test_env

    # Test summary
    print_header "📊 Test Results"
    printf "Total Tests: %d\n" "$TOTAL_TESTS"
    printf "\e[32mPassed: %d\e[0m\n" "$PASSED_TESTS"
    printf "\e[31mFailed: %d\e[0m\n" "$FAILED_TESTS"

    if [[ $FAILED_TESTS -eq 0 ]]; then
        printf "\n\e[32m🎉 All tests passed!\e[0m\n"
        exit 0
    else
        printf "\n\e[31m💥 %d test(s) failed!\e[0m\n" "$FAILED_TESTS"
        exit 1
    fi
}

# Run tests
main "$@"
