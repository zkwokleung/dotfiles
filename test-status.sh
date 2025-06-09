#!/bin/bash

# 📊 Test Status Reporter
# Quick script to show current test status and pipeline health

set -e

# Color functions
print_header() {
    printf "\n\e[1;35m=== %s ===\e[0m\n" "$1"
}

print_success() {
    printf "\e[32m✅ %s\e[0m\n" "$1"
}

print_info() {
    printf "\e[34mℹ️  %s\e[0m\n" "$1"
}

print_warning() {
    printf "\e[33m⚠️  %s\e[0m\n" "$1"
}

# Quick test function
quick_test() {
    local test_name="$1"
    local test_command="$2"

    if $test_command >/dev/null 2>&1; then
        print_success "$test_name"
        return 0
    else
        print_warning "$test_name"
        return 1
    fi
}

main() {
    print_header "📊 Dotfiles Test Status"

    print_info "Repository: $(pwd)"
    print_info "Branch: $(git branch --show-current 2>/dev/null || echo 'unknown')"
    print_info "Last commit: $(git log -1 --oneline 2>/dev/null || echo 'unknown')"

    print_header "🔍 Quick Health Check"

    # Quick validation checks
    if [[ -f setup.sh && -f bootstrap.sh && -f health-check.sh ]]; then
        print_success "Required files exist"
    else
        print_warning "Required files exist"
    fi

    if [[ -x setup.sh && -x bootstrap.sh && -x health-check.sh ]]; then
        print_success "Scripts are executable"
    else
        print_warning "Scripts are executable"
    fi

    if python3 -m json.tool .vscode/settings.json >/dev/null 2>&1; then
        print_success "JSON syntax valid"
    else
        print_warning "JSON syntax valid"
    fi

    if bash -n .aliases && bash -n .functions && bash -n .exports 2>/dev/null; then
        print_success "Shell syntax valid"
    else
        print_warning "Shell syntax valid"
    fi

    if git config --file .gitconfig --list >/dev/null 2>&1; then
        print_success "Git config valid"
    else
        print_warning "Git config valid"
    fi

    print_header "🚀 Test Suite Commands"
    print_info "Run all tests:           ./run-tests.sh"
    print_info "Configuration tests:     ./run-tests.sh --config"
    print_info "Integration tests:       ./run-tests.sh --integration"
    print_info "Security tests:          ./run-tests.sh --security"
    print_info "Health check:            ./health-check.sh"

    print_header "📋 Pipeline Information"
    print_info "GitHub Actions:          .github/workflows/test.yml"
    print_info "Test configuration:      tests/"
    print_info "Badge URL:               https://github.com/zkwokleung/dotfiles/actions/workflows/test.yml/badge.svg"

    printf "\n\e[34m💡 Tip: Run './run-tests.sh' for a comprehensive test suite\e[0m\n"
}

# Show help
if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
    cat << EOF
📊 Dotfiles Test Status Reporter

Usage: $0

This script provides a quick overview of:
- Repository status
- Basic health checks
- Available test commands
- Pipeline information

For comprehensive testing, use: ./run-tests.sh

EOF
    exit 0
fi

main "$@"
