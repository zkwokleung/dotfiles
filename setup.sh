#!/bin/bash

# Exit on any error
set -e

# Color output functions
print_info() {
    printf "\e[34m[INFO]\e[0m %s\n" "$1"
}

print_success() {
    printf "\e[32m[SUCCESS]\e[0m %s\n" "$1"
}

print_error() {
    printf "\e[31m[ERROR]\e[0m %s\n" "$1"
}

print_warning() {
    printf "\e[33m[WARNING]\e[0m %s\n" "$1"
}

declare -a req=(
    "eza"
    "thefuck"
    "tlrc"
    "bat"
    "diff-so-fancy"
    "nvim"
    "tmux"
    "ast-grep"
    "fzf"
    "tree-sitter"
    "fontconfig"
    "zsh-autosuggestions"
    "zsh-syntax-highlighting"
    "ripgrep"
    "the_silver_searcher"
    "entr"
    "shortcat"
)

# Function to check if a package is installed
check_brew_package() {
    brew list "$1" &>/dev/null
}

# Install dependencies on macOS
if [[ "$OSTYPE" == "darwin"* ]]; then
    print_info "Detected macOS, installing dependencies with Homebrew..."

    # Check if brew command exists
    if ! command -v brew &>/dev/null; then
        print_info "Homebrew not found, installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || {
            print_error "Failed to install Homebrew"
            exit 1
        }

        # Add Homebrew to PATH for the current session
        if [[ -f "/opt/homebrew/bin/brew" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
            print_info "Added Homebrew (Apple Silicon) to PATH"
        elif [[ -f "/usr/local/bin/brew" ]]; then
            eval "$(/usr/local/bin/brew shellenv)"
            print_info "Added Homebrew (Intel) to PATH"
        fi

        print_success "Homebrew installed successfully"
    else
        print_info "Homebrew found, updating..."
        brew update || print_warning "Failed to update Homebrew"
    fi

    # Install requirements
    print_info "Installing required packages..."
    failed_packages=()

    for package in "${req[@]}"; do
        if ! check_brew_package "$package"; then
            print_info "Installing $package..."
            if brew install "$package"; then
                print_success "Installed $package"
            else
                print_error "Failed to install $package"
                failed_packages+=("$package")
            fi
        else
            print_info "$package is already installed"
        fi
    done

    # Install cask packages
    print_info "Installing GUI applications..."
    if ! check_brew_package "linearmouse"; then
        print_info "Installing linearmouse..."
        if brew install --cask linearmouse; then
            print_success "Installed linearmouse"
        else
            print_warning "Failed to install linearmouse (this is optional)"
        fi
    else
        print_info "linearmouse is already installed"
    fi

    # Report any failed packages
    if [ ${#failed_packages[@]} -gt 0 ]; then
        print_warning "The following packages failed to install:"
        for package in "${failed_packages[@]}"; do
            printf "  - %s\n" "$package"
        done
        print_info "You may need to install these manually"
    fi

    # Rebuild zsh completions
    if command -v brew &>/dev/null; then
        print_info "Rebuilding zsh completions..."
        if [[ -d $(brew --prefix)/share/zsh-completions ]]; then
            print_success "Zsh completions directory found"
        fi
    fi

else
    print_warning "Non-macOS system detected. This script is optimized for macOS."
    print_info "Please install the required packages manually using your system's package manager"
    exit 0
fi

# Install bun (cross-platform)
print_info "Installing bun..."
if ! command -v bun &>/dev/null; then
    if curl -fsSL https://bun.sh/install | bash; then
        print_success "Bun installed successfully"
        print_info "Adding bun to PATH for current session..."
        export BUN_INSTALL="$HOME/.bun"
        export PATH="$BUN_INSTALL/bin:$PATH"
    else
        print_error "Failed to install bun"
    fi
else
    print_info "Bun is already installed"
fi

# Final instructions
print_success "🎉 Installation completed!"
print_info "Next steps:"
print_info "1. Restart your terminal or run: source ~/.zshrc"
print_info "2. Run: ./bootstrap.sh to install the dotfiles"
print_info "3. Enjoy your enhanced terminal experience!"

# Check if any critical tools are missing
critical_tools=("git" "zsh")
missing_critical=()

for tool in "${critical_tools[@]}"; do
    if ! command -v "$tool" &>/dev/null; then
        missing_critical+=("$tool")
    fi
done

if [ ${#missing_critical[@]} -gt 0 ]; then
    print_warning "Critical tools missing:"
    for tool in "${missing_critical[@]}"; do
        printf "  - %s\n" "$tool"
    done
    print_info "Please install these before proceeding"
fi
