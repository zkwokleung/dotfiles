#!/bin/bash

# 🏥 Dotfiles Health Check Script
# Verifies all components are installed and working properly

set -e

# Color output functions
print_header() {
    printf "\n\e[1;36m=== %s ===\e[0m\n" "$1"
}

print_success() {
    printf "\e[32m✅ %s\e[0m\n" "$1"
}

print_warning() {
    printf "\e[33m⚠️  %s\e[0m\n" "$1"
}

print_error() {
    printf "\e[31m❌ %s\e[0m\n" "$1"
}

print_info() {
    printf "\e[34mℹ️  %s\e[0m\n" "$1"
}

print_check() {
    printf "\e[90m🔍 Checking %s...\e[0m\n" "$1"
}

# Global counters
TOTAL_CHECKS=0
PASSED_CHECKS=0
FAILED_CHECKS=0
WARNING_CHECKS=0

# Function to increment counters
check_result() {
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    case $1 in
        "pass") PASSED_CHECKS=$((PASSED_CHECKS + 1)) ;;
        "fail") FAILED_CHECKS=$((FAILED_CHECKS + 1)) ;;
        "warn") WARNING_CHECKS=$((WARNING_CHECKS + 1)) ;;
    esac
}

# Function to check if command exists and get version
check_command() {
    local cmd=$1
    local name=${2:-$cmd}
    local version_flag=${3:---version}
    
    print_check "$name"
    
    if command -v "$cmd" &>/dev/null; then
        local version
        version=$($cmd $version_flag 2>/dev/null | head -n1 || echo "Version unknown")
        print_success "$name is installed: $version"
        check_result "pass"
        return 0
    else
        print_error "$name is not installed"
        check_result "fail"
        return 1
    fi
}

# Function to check file exists
check_file() {
    local file=$1
    local name=$2
    
    print_check "$name"
    
    if [[ -f "$file" ]]; then
        print_success "$name exists: $file"
        check_result "pass"
        return 0
    else
        print_error "$name not found: $file"
        check_result "fail"
        return 1
    fi
}

# Function to check directory exists
check_directory() {
    local dir=$1
    local name=$2
    
    print_check "$name"
    
    if [[ -d "$dir" ]]; then
        print_success "$name exists: $dir"
        check_result "pass"
        return 0
    else
        print_error "$name not found: $dir"
        check_result "fail"
        return 1
    fi
}

# Main health check
main() {
    print_header "🏠 Dotfiles Health Check"
    printf "Checking your dotfiles installation...\n\n"

    # System Information
    print_header "📋 System Information"
    print_info "OS: $(uname -s) $(uname -r)"
    print_info "Shell: $SHELL"
    print_info "User: $USER"
    print_info "Home: $HOME"
    
    # Core Tools Check
    print_header "🔧 Core Tools"
    check_command "git" "Git"
    check_command "zsh" "Zsh"
    check_command "tmux" "Tmux"
    check_command "brew" "Homebrew"
    
    # Essential Modern Tools
    print_header "⚡ Modern CLI Tools"
    check_command "eza" "eza (modern ls)"
    check_command "bat" "bat (modern cat)"
    check_command "fzf" "fzf (fuzzy finder)"
    check_command "rg" "ripgrep"
    check_command "ag" "the_silver_searcher"
    check_command "starship" "Starship prompt"
    check_command "zoxide" "Zoxide"
    check_command "nvim" "Neovim"
    check_command "thefuck" "thefuck"
    check_command "diff-so-fancy" "diff-so-fancy"
    
    # Development Tools
    print_header "👨‍💻 Development Tools"
    check_command "node" "Node.js" "-v"
    check_command "npm" "npm"
    check_command "bun" "Bun"
    check_command "python3" "Python 3"
    check_command "pip3" "pip3"
    
    # Configuration Files
    print_header "📄 Configuration Files"
    check_file "$HOME/.zshrc" "Zsh config"
    check_file "$HOME/.bash_profile" "Bash profile"
    check_file "$HOME/.aliases" "Aliases"
    check_file "$HOME/.functions" "Functions"
    check_file "$HOME/.exports" "Exports"
    check_file "$HOME/.gitconfig" "Git config"
    check_file "$HOME/.config/starship.toml" "Starship config"
    check_file "$HOME/.config/tmux/tmux.conf.local" "Tmux config"
    check_file "$HOME/.config/tmux/gitmux.conf" "Gitmux config"
    
    # Tmux Plugin Check
    print_header "🔌 Tmux Plugins"
    if [[ -d "$HOME/.tmux/plugins" ]]; then
        print_check "Tmux plugin directory"
        print_success "Tmux plugins directory exists"
        check_result "pass"
        
        # Check specific plugins
        local plugins=(
            "tpm:Tmux Plugin Manager"
            "tmux-resurrect:Session Restore"
            "tmux-continuum:Auto Save/Restore"
            "tmux-thumbs:Quick Text Copy"
        )
        
        for plugin_info in "${plugins[@]}"; do
            IFS=':' read -r plugin_name plugin_desc <<< "$plugin_info"
            print_check "$plugin_desc"
            if [[ -d "$HOME/.tmux/plugins/$plugin_name" ]]; then
                print_success "$plugin_desc is installed"
                check_result "pass"
            else
                print_warning "$plugin_desc not installed (run Prefix + I in tmux)"
                check_result "warn"
            fi
        done
    else
        print_error "Tmux plugins directory not found"
        check_result "fail"
    fi
    
    # Shell Integration Tests
    print_header "🔗 Shell Integration"
    
    # Test zoxide integration
    print_check "Zoxide integration"
    if command -v zoxide &>/dev/null && zoxide query --help &>/dev/null; then
        print_success "Zoxide is properly integrated"
        check_result "pass"
    else
        print_warning "Zoxide may not be properly initialized"
        check_result "warn"
    fi
    
    # Test starship integration
    print_check "Starship integration"
    if command -v starship &>/dev/null; then
        if starship config --help &>/dev/null; then
            print_success "Starship is properly integrated"
            check_result "pass"
        else
            print_warning "Starship found but may not be initialized"
            check_result "warn"
        fi
    else
        print_error "Starship not found"
        check_result "fail"
    fi
    
    # Git Configuration Check
    print_header "📝 Git Configuration"
    print_check "Git user configuration"
    local git_user
    local git_email
    git_user=$(git config --global user.name 2>/dev/null || echo "Not set")
    git_email=$(git config --global user.email 2>/dev/null || echo "Not set")
    
    if [[ "$git_user" != "Not set" && "$git_email" != "Not set" ]]; then
        print_success "Git user configured: $git_user <$git_email>"
        check_result "pass"
    else
        print_warning "Git user not fully configured (name: $git_user, email: $git_email)"
        check_result "warn"
    fi
    
    print_check "Git diff configuration"
    local git_pager
    git_pager=$(git config --global core.pager 2>/dev/null || echo "Not set")
    if [[ "$git_pager" == *"diff-so-fancy"* ]]; then
        print_success "Git is configured to use diff-so-fancy"
        check_result "pass"
    else
        print_warning "Git not configured for diff-so-fancy: $git_pager"
        check_result "warn"
    fi
    
    # Aliases Check
    print_header "🏷️  Aliases"
    print_check "Essential aliases"
    local essential_aliases=("ll" "la" "gs" "ga" "gc" "v" "py")
    local missing_aliases=()
    
    for alias_name in "${essential_aliases[@]}"; do
        if alias "$alias_name" &>/dev/null; then
            print_success "Alias '$alias_name' is available"
            check_result "pass"
        else
            missing_aliases+=("$alias_name")
            check_result "warn"
        fi
    done
    
    if [[ ${#missing_aliases[@]} -gt 0 ]]; then
        print_warning "Missing aliases: ${missing_aliases[*]}"
    fi
    
    # Permissions Check
    print_header "🔐 Permissions"
    print_check "Script permissions"
    if [[ -x "./setup.sh" && -x "./bootstrap.sh" ]]; then
        print_success "Setup scripts have execute permissions"
        check_result "pass"
    else
        print_warning "Setup scripts may not be executable"
        check_result "warn"
    fi
    
    # Final Summary
    print_header "📊 Health Check Summary"
    printf "\n"
    printf "Total Checks: %d\n" "$TOTAL_CHECKS"
    printf "\e[32m✅ Passed: %d\e[0m\n" "$PASSED_CHECKS"
    printf "\e[33m⚠️  Warnings: %d\e[0m\n" "$WARNING_CHECKS"
    printf "\e[31m❌ Failed: %d\e[0m\n" "$FAILED_CHECKS"
    printf "\n"
    
    # Health Score
    local health_score
    if [[ $TOTAL_CHECKS -gt 0 ]]; then
        health_score=$(( (PASSED_CHECKS * 100) / TOTAL_CHECKS ))
        printf "Health Score: %d%%\n" "$health_score"
        
        if [[ $health_score -ge 90 ]]; then
            printf "\e[32m🎉 Excellent! Your dotfiles are in great shape!\e[0m\n"
        elif [[ $health_score -ge 75 ]]; then
            printf "\e[33m👍 Good! A few minor issues to address.\e[0m\n"
        elif [[ $health_score -ge 50 ]]; then
            printf "\e[33m⚠️  Fair. Several components need attention.\e[0m\n"
        else
            printf "\e[31m🔧 Poor. Significant issues need to be resolved.\e[0m\n"
        fi
    fi
    
    # Recommendations
    if [[ $FAILED_CHECKS -gt 0 || $WARNING_CHECKS -gt 0 ]]; then
        printf "\n"
        print_header "💡 Recommendations"
        
        if [[ $FAILED_CHECKS -gt 0 ]]; then
            print_info "To fix failed checks:"
            print_info "1. Run './setup.sh' to install missing tools"
            print_info "2. Run './bootstrap.sh' to update configuration files"
        fi
        
        if [[ $WARNING_CHECKS -gt 0 ]]; then
            print_info "To address warnings:"
            print_info "1. Restart your terminal or run 'source ~/.zshrc'"
            print_info "2. Install tmux plugins with 'Prefix + I' in tmux"
            print_info "3. Configure git user: 'git config --global user.name \"Your Name\"'"
            print_info "4. Configure git email: 'git config --global user.email \"your@email.com\""
        fi
    fi
    
    printf "\n"
    print_info "For more help, check the README.md or run individual setup scripts."
    printf "\n"
}

# Run the health check
main "$@" 