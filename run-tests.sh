#!/bin/bash

# 🧪 Local Test Runner
# Run all dotfiles tests locally with CI-like environment

set -e

# Test configuration
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FAILED_SUITES=0
TOTAL_SUITES=0

# Color functions
print_header() {
    printf "\n\e[1;35m=== %s ===\e[0m\n" "$1"
}

print_success() {
    printf "\e[32m✅ %s\e[0m\n" "$1"
}

print_failure() {
    printf "\e[31m❌ %s\e[0m\n" "$1"
}

print_info() {
    printf "\e[34mℹ️  %s\e[0m\n" "$1"
}

print_warning() {
    printf "\e[33m⚠️  %s\e[0m\n" "$1"
}

# Test runner function
run_test_suite() {
    local suite_name="$1"
    local test_function="$2"

    TOTAL_SUITES=$((TOTAL_SUITES + 1))
    print_header "$suite_name"

    if $test_function; then
        print_success "$suite_name completed successfully"
        return 0
    else
        print_failure "$suite_name failed"
        FAILED_SUITES=$((FAILED_SUITES + 1))
        return 1
    fi
}

# Configuration tests
run_config_tests() {
    print_info "Running configuration validation tests..."

    # Check if test script exists
    if [[ ! -f "tests/test-config.sh" ]]; then
        print_failure "Configuration test script not found"
        return 1
    fi

    # Make executable and run
    chmod +x tests/test-config.sh
    ./tests/test-config.sh
}

# Integration tests
run_integration_tests() {
    print_info "Running integration tests..."

    # Check if test script exists
    if [[ ! -f "tests/test-integration.sh" ]]; then
        print_failure "Integration test script not found"
        return 1
    fi

    # Make executable and run
    chmod +x tests/test-integration.sh
    ./tests/test-integration.sh
}

# Security tests
run_security_tests() {
    print_info "Running security validation tests..."

    # Check for hardcoded secrets
    print_info "Checking for hardcoded secrets..."
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
        print_failure "Potential hardcoded secrets found"
        return 1
    fi

    # Check file permissions
    print_info "Checking file permissions..."
    for script in setup.sh bootstrap.sh health-check.sh; do
        if [[ -f "$script" && ! -x "$script" ]]; then
            print_failure "Script $script is not executable"
            return 1
        fi
    done

    # Check for unsafe operations
    print_info "Checking for unsafe operations..."
    if grep -r "rm -rf /" . \
        --exclude-dir=.git \
        --exclude-dir=tests \
        --exclude-dir=.github \
        --exclude="*.md" \
        --exclude="*.yml" \
        --exclude="*.yaml" \
        --exclude="run-tests.sh" 2>/dev/null; then
        print_failure "Potentially unsafe rm operations found"
        return 1
    fi

    return 0
}

# Health check tests
run_health_check_tests() {
    print_info "Running health check tests..."

    # Make sure health check is executable
    chmod +x health-check.sh

    # Run bootstrap first
    print_info "Running bootstrap for health check test..."
    if ./bootstrap.sh --force >/dev/null 2>&1; then
        print_info "Running health check..."
        if CI=true ./health-check.sh >/dev/null 2>&1; then
            return 0
        else
            print_failure "Health check failed"
            return 1
        fi
    else
        print_failure "Bootstrap failed, can't run health check"
        return 1
    fi
}

# Compatibility tests
run_compatibility_tests() {
    print_info "Running compatibility tests..."

    # Test bash compatibility
    print_info "Testing bash compatibility..."
    if bash -c "source .aliases && source .functions" 2>/dev/null; then
        print_info "Bash compatibility: OK"
    else
        print_warning "Bash compatibility issues detected"
    fi

    # Test zsh compatibility (if available)
    if command -v zsh >/dev/null 2>&1; then
        print_info "Testing zsh compatibility..."
        if zsh -c "source .aliases && source .functions" 2>/dev/null; then
            print_info "Zsh compatibility: OK"
        else
            print_warning "Zsh compatibility issues detected"
        fi
    else
        print_info "Zsh not available, skipping zsh compatibility test"
    fi

    # Test script syntax
    print_info "Testing script syntax..."
    for script in setup.sh bootstrap.sh health-check.sh; do
        if [[ -f "$script" ]]; then
            if ! bash -n "$script" 2>/dev/null; then
                print_failure "Syntax error in $script"
                return 1
            fi
        fi
    done

    return 0
}

# Documentation tests
run_docs_tests() {
    print_info "Running documentation tests..."

    # Check if README exists
    if [[ ! -f "README.md" ]]; then
        print_failure "README.md not found"
        return 1
    fi

    # Check if essential sections exist in README
    local required_sections=("Installation" "Features" "Usage")
    for section in "${required_sections[@]}"; do
        if ! grep -i "$section" README.md >/dev/null 2>&1; then
            print_warning "README missing '$section' section"
        fi
    done

    return 0
}

# Syntax validation tests
run_syntax_tests() {
    print_info "Running syntax validation tests..."

    # Check shell scripts
    for file in .aliases .functions .exports .bash_profile; do
        if [[ -f "$file" ]]; then
            if ! bash -n "$file" 2>/dev/null; then
                print_failure "Syntax error in $file"
                return 1
            fi
        fi
    done

    # Check JSON files
    if [[ -f ".vscode/settings.json" ]]; then
        if command -v python3 >/dev/null 2>&1; then
            if ! python3 -m json.tool .vscode/settings.json >/dev/null 2>&1; then
                print_failure "Invalid JSON in .vscode/settings.json"
                return 1
            fi
        fi
    fi

    # Check YAML files
    if [[ -f ".gitmux.yaml" ]]; then
        if command -v yamllint >/dev/null 2>&1; then
            # Check for syntax errors only, ignore warnings
            if ! yamllint -d "{extends: relaxed, rules: {line-length: {max: 120}}}" ".gitmux.yaml" 2>/dev/null; then
                print_failure "Invalid YAML in .gitmux.yaml"
                return 1
            fi
        elif command -v python3 >/dev/null 2>&1; then
            if ! python3 -c "import yaml; yaml.safe_load(open('.gitmux.yaml'))" 2>/dev/null; then
                print_failure "Invalid YAML in .gitmux.yaml"
                return 1
            fi
        fi
    fi

    return 0
}

# Main test runner
main() {
    print_header "🧪 Dotfiles Local Test Suite"
    print_info "Running tests in: $PROJECT_ROOT"

    cd "$PROJECT_ROOT"

    # Make sure scripts are executable
    chmod +x setup.sh bootstrap.sh health-check.sh 2>/dev/null || true

    # Run all test suites
    run_test_suite "📄 Configuration Tests" run_config_tests
    run_test_suite "🚀 Integration Tests" run_integration_tests
    run_test_suite "🔒 Security Tests" run_security_tests
    run_test_suite "🏥 Health Check Tests" run_health_check_tests
    run_test_suite "🔄 Compatibility Tests" run_compatibility_tests
    run_test_suite "📚 Documentation Tests" run_docs_tests
    run_test_suite "🔍 Syntax Tests" run_syntax_tests

    # Final summary
    print_header "📊 Test Results Summary"
    printf "Total Test Suites: %d\n" "$TOTAL_SUITES"
    printf "\e[32mPassed: %d\e[0m\n" "$((TOTAL_SUITES - FAILED_SUITES))"
    printf "\e[31mFailed: %d\e[0m\n" "$FAILED_SUITES"

    if [[ $FAILED_SUITES -eq 0 ]]; then
        printf "\n\e[32m🎉 All test suites passed!\e[0m\n"
        printf "\e[32m✨ Your dotfiles are ready for deployment!\e[0m\n"
        exit 0
    else
        printf "\n\e[31m💥 %d test suite(s) failed!\e[0m\n" "$FAILED_SUITES"
        printf "\e[33m🔧 Please fix the issues before deployment.\e[0m\n"
        exit 1
    fi
}

# Show help
show_help() {
    cat << EOF
🧪 Dotfiles Local Test Runner

Usage: $0 [OPTIONS]

Options:
  -h, --help     Show this help message
  --config       Run only configuration tests
  --integration  Run only integration tests
  --security     Run only security tests
  --health       Run only health check tests
  --compat       Run only compatibility tests
  --docs         Run only documentation tests
  --syntax       Run only syntax tests

Examples:
  $0                    # Run all tests
  $0 --config          # Run only config tests
  $0 --integration     # Run only integration tests

EOF
}

# Parse command line arguments
case "${1:-}" in
    -h|--help)
        show_help
        exit 0
        ;;
    --config)
        run_test_suite "📄 Configuration Tests" run_config_tests
        exit $?
        ;;
    --integration)
        run_test_suite "🚀 Integration Tests" run_integration_tests
        exit $?
        ;;
    --security)
        run_test_suite "🔒 Security Tests" run_security_tests
        exit $?
        ;;
    --health)
        run_test_suite "🏥 Health Check Tests" run_health_check_tests
        exit $?
        ;;
    --compat)
        run_test_suite "🔄 Compatibility Tests" run_compatibility_tests
        exit $?
        ;;
    --docs)
        run_test_suite "📚 Documentation Tests" run_docs_tests
        exit $?
        ;;
    --syntax)
        run_test_suite "🔍 Syntax Tests" run_syntax_tests
        exit $?
        ;;
    "")
        main
        ;;
    *)
        echo "Unknown option: $1"
        show_help
        exit 1
        ;;
esac
