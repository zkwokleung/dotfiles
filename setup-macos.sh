#!/bin/bash

# macOS Setup Script
# Installs Homebrew and required packages for the dotfiles environment

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

print_info "🍎 Setting up macOS development environment..."

# Verify we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
  print_error "This script is for macOS only. Use setup-linux.sh for Linux systems."
  exit 1
fi

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
  "starship"
  "zoxide"
  "lazygit"
  "gh"
  "luarocks"
)

declare -a cask_req=(
  "linearmouse"
  "alt-tab"
)

# Function to check if a package is installed
check_brew_package() {
  brew list "$1" &>/dev/null
}

# Function to check if a cask package is installed
check_brew_cask() {
  brew list --cask "$1" &>/dev/null
}

# Install Homebrew and all brew-managed packages
install_brew_dependencies() {
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
  for cask in "${cask_req[@]}"; do
    if ! check_brew_cask "$cask"; then
      print_info "Installing $cask..."
      if brew install --cask "$cask"; then
        print_success "Installed $cask"
      else
        print_warning "Failed to install $cask (this is optional)"
        failed_casks+=("$cask")
      fi
    else
      print_info "$cask is already installed"
    fi
  done

  # Rebuild zsh completions
  print_info "Rebuilding zsh completions..."
  if [[ -d $(brew --prefix)/share/zsh-completions ]]; then
    print_success "Zsh completions directory found"
  fi
}

# Install Node.js tooling in one place (nvm, yarn, pnpm, bun)
install_node_ecosystem() {
  print_info "Installing Node.js ecosystem (nvm, yarn, pnpm, bun)..."

  # Install NVM
  if [[ ! -d "$HOME/.nvm" ]]; then
    print_info "Installing NVM..."
    if curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash; then
      print_success "NVM installed successfully"
    else
      print_error "Failed to install NVM"
      return
    fi
  else
    print_info "NVM is already installed"
  fi

  # Source NVM for the current session
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

  if command -v nvm &>/dev/null; then
    print_info "Installing Node.js LTS via NVM..."
    if nvm install --lts && nvm use --lts; then
      print_success "Node.js LTS is ready"
    else
      print_warning "Failed to install/use Node.js LTS via NVM"
    fi
  else
    print_warning "NVM is not available in current shell; skipping Node.js, yarn, and pnpm setup"
  fi

  # Install yarn and pnpm
  if command -v node &>/dev/null; then
    if command -v corepack &>/dev/null; then
      print_info "Enabling Corepack for yarn and pnpm..."
      corepack enable || print_warning "Failed to enable Corepack"
      corepack prepare yarn@stable --activate || print_warning "Failed to activate yarn via Corepack"
      corepack prepare pnpm@latest --activate || print_warning "Failed to activate pnpm via Corepack"
    else
      print_warning "Corepack not found; falling back to npm global install for yarn and pnpm"
      command -v yarn &>/dev/null || npm install -g yarn || print_warning "Failed to install yarn"
      command -v pnpm &>/dev/null || npm install -g pnpm || print_warning "Failed to install pnpm"
    fi

    command -v yarn &>/dev/null && print_success "yarn is available" || print_warning "yarn is not available"
    command -v pnpm &>/dev/null && print_success "pnpm is available" || print_warning "pnpm is not available"
  fi

  # Install bun
  if ! command -v bun &>/dev/null; then
    print_info "Installing bun..."
    if curl -fsSL https://bun.sh/install | bash; then
      print_success "Bun installed successfully"
      export BUN_INSTALL="$HOME/.bun"
      export PATH="$BUN_INSTALL/bin:$PATH"
    else
      print_warning "Failed to install bun"
    fi
  else
    print_info "Bun is already installed"
  fi
}

failed_packages=()
failed_casks=()
install_brew_dependencies

# Install Node.js tooling
install_node_ecosystem

# Report any failed packages
if [ ${#failed_packages[@]} -gt 0 ]; then
  print_warning "The following packages failed to install:"
  for package in "${failed_packages[@]}"; do
    printf "  - %s\n" "$package"
  done
  print_info "You may need to install these manually"
fi

if [ ${#failed_casks[@]} -gt 0 ]; then
  print_warning "The following cask packages failed to install:"
  for cask in "${failed_casks[@]}"; do
    printf "  - %s\n" "$cask"
  done
  print_info "You may need to install these manually"
fi

# Final instructions
print_success "🎉 macOS setup completed!"
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
