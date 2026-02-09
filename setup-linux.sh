#!/bin/bash

# Linux Setup Script
# Installs essential development tools and packages for the dotfiles environment

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

print_info "🐧 Setting up Linux development environment..."

# Verify we're on Linux
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
  print_error "This script is for Linux only. Use setup-macos.sh for macOS systems."
  exit 1
fi

# Check if running as root or with sudo
if [[ $EUID -ne 0 ]]; then
  print_warning "Some packages may require sudo privileges"
  SUDO="sudo"
else
  SUDO=""
fi

# Detect package manager
if command -v apt-get &>/dev/null; then
  PKG_MANAGER="apt"
  print_info "Using apt package manager..."
elif command -v dnf &>/dev/null; then
  PKG_MANAGER="dnf"
  print_info "Using dnf package manager..."
elif command -v yum &>/dev/null; then
  PKG_MANAGER="yum"
  print_info "Using yum package manager..."
elif command -v pacman &>/dev/null; then
  PKG_MANAGER="pacman"
  print_info "Using pacman package manager..."
else
  print_error "No supported package manager found (apt, dnf, yum, pacman)"
  exit 1
fi

# Function to check if a package is installed
check_linux_package() {
  local package="$1"
  case $PKG_MANAGER in
  "apt")
    dpkg -l | grep -q "^ii  $package "
    ;;
  "yum" | "dnf")
    $PKG_MANAGER list installed "$package" &>/dev/null
    ;;
  "pacman")
    pacman -Q "$package" &>/dev/null
    ;;
  *)
    return 1
    ;;
  esac
}

# Function to install package
install_linux_package() {
  local package="$1"
  case $PKG_MANAGER in
  "apt")
    $SUDO apt install -y "$package"
    ;;
  "yum")
    $SUDO yum install -y "$package"
    ;;
  "dnf")
    $SUDO dnf install -y "$package"
    ;;
  "pacman")
    $SUDO pacman -S --noconfirm "$package"
    ;;
  *)
    return 1
    ;;
  esac
}

# Function to update package lists
update_packages() {
  case $PKG_MANAGER in
  "apt")
    $SUDO apt-get update
    ;;
  "yum")
    $SUDO yum check-update || true
    ;;
  "dnf")
    $SUDO dnf check-update || true
    ;;
  "pacman")
    $SUDO pacman -Sy
    ;;
  esac
}

install_package_manager_dependencies() {
  # Update package lists
  print_info "Updating package lists..."
  update_packages

  # Install essential development tools
  print_info "Installing essential development tools..."

  essential_tools=()
  case $PKG_MANAGER in
  "apt")
    essential_tools=(
      "build-essential"
      "software-properties-common"
      "apt-transport-https"
      "ca-certificates"
      "gnupg"
      "lsb-release"
      "curl"
      "wget"
      "git"
      "zsh"
      "unzip"
      "tar"
      "gzip"
      "python3"
      "python3-pip"
      "python3-dev"
      "python3-setuptools"
      "python3-venv"
    )
    ;;
  "dnf" | "yum")
    essential_tools=(
      "gcc"
      "gcc-c++"
      "make"
      "kernel-devel"
      "curl"
      "wget"
      "git"
      "zsh"
      "unzip"
      "tar"
      "gzip"
      "python3"
      "python3-pip"
      "python3-devel"
      "openssl-devel"
      "libffi-devel"
      "bzip2-devel"
      "readline-devel"
      "sqlite-devel"
    )
    ;;
  "pacman")
    essential_tools=(
      "base-devel"
      "curl"
      "wget"
      "git"
      "zsh"
      "unzip"
      "tar"
      "gzip"
      "python"
      "python-pip"
    )
    ;;
  esac

  for package in "${essential_tools[@]}"; do
    if ! check_linux_package "$package"; then
      print_info "Installing $package..."
      if install_linux_package "$package"; then
        print_success "Installed $package"
      else
        print_error "Failed to install $package"
        failed_packages+=("$package")
      fi
    else
      print_info "$package is already installed"
    fi
  done

  # Install dotfiles-specific packages
  print_info "Installing dotfiles-specific packages..."

  dotfiles_packages=()
  case $PKG_MANAGER in
  "apt")
    dotfiles_packages=(
      "tldr"
      "bat"
      "tmux"
      "fzf"
      "fontconfig"
      "ripgrep"
      "silversearcher-ag"
      "entr"
    )
    ;;
  "dnf" | "yum")
    dotfiles_packages=(
      "bat"
      "neovim"
      "tmux"
      "fzf"
      "fontconfig"
      "ripgrep"
      "the_silver_searcher"
      "entr"
    )
    ;;
  "pacman")
    dotfiles_packages=(
      "bat"
      "neovim"
      "tmux"
      "fzf"
      "fontconfig"
      "ripgrep"
      "the_silver_searcher"
      "entr"
    )
    ;;
  esac

  for package in "${dotfiles_packages[@]}"; do
    if ! check_linux_package "$package"; then
      print_info "Installing $package..."
      if install_linux_package "$package"; then
        print_success "Installed $package"
      else
        print_error "Failed to install $package"
        failed_packages+=("$package")
      fi
    else
      print_info "$package is already installed"
    fi
  done
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
      print_warning "Failed to install NVM"
      failed_packages+=("nvm")
      return
    fi
  else
    print_info "NVM is already installed"
  fi

  # Source NVM for current session
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

  if command -v nvm &>/dev/null; then
    print_info "Installing Node.js LTS via NVM..."
    if nvm install --lts && nvm use --lts; then
      print_success "Node.js LTS is ready"
    else
      print_warning "Failed to install/use Node.js LTS via NVM"
      failed_packages+=("nodejs-lts")
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

    command -v yarn &>/dev/null && print_success "yarn is available" || {
      print_warning "yarn is not available"
      failed_packages+=("yarn")
    }
    command -v pnpm &>/dev/null && print_success "pnpm is available" || {
      print_warning "pnpm is not available"
      failed_packages+=("pnpm")
    }
  fi

  # Install bun
  if ! command -v bun &>/dev/null; then
    print_info "Installing bun..."
    if curl -fsSL https://bun.sh/install | bash; then
      print_success "Bun installed successfully"
      export BUN_INSTALL="$HOME/.bun"
      export PATH="$BUN_INSTALL/bin:$PATH"
    else
      print_error "Failed to install bun"
      failed_packages+=("bun")
    fi
  else
    print_info "Bun is already installed"
  fi
}
failed_packages=()
install_package_manager_dependencies

# Install Miniconda (Python environment management)
print_info "Installing Miniconda..."
if ! command -v conda &>/dev/null; then
  MINICONDA_DIR="$HOME/miniconda3"
  if [[ ! -d "$MINICONDA_DIR" ]]; then
    print_info "Downloading Miniconda installer..."
    ARCH=$(uname -m)
    if [[ "$ARCH" == "x86_64" ]]; then
      MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
    elif [[ "$ARCH" == "aarch64" ]]; then
      MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh"
    else
      print_warning "Unsupported architecture: $ARCH. Skipping Miniconda installation."
    fi

    if [[ -n "$MINICONDA_URL" ]]; then
      wget "$MINICONDA_URL" -O /tmp/miniconda.sh
      bash /tmp/miniconda.sh -b -p "$MINICONDA_DIR"
      rm /tmp/miniconda.sh

      # Initialize conda for bash and zsh
      "$MINICONDA_DIR/bin/conda" init bash
      "$MINICONDA_DIR/bin/conda" init zsh

      print_success "Miniconda installed successfully"
    fi
  else
    print_info "Miniconda directory already exists"
  fi
else
  print_info "Conda is already installed"
fi

# Install packages that might not be available through package managers
print_info "Installing additional tools..."

# Install starship
if ! command -v starship &>/dev/null; then
  print_info "Installing starship..."
  if curl -sS https://starship.rs/install.sh | sh -s -- -y; then
    print_success "Installed starship"
  else
    print_warning "Failed to install starship"
    failed_packages+=("starship")
  fi
else
  print_info "Starship is already installed"
fi

# Install zoxide
if ! command -v zoxide &>/dev/null; then
  print_info "Installing zoxide..."
  if curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash; then
    print_success "Installed zoxide"
  else
    print_warning "Failed to install zoxide"
    failed_packages+=("zoxide")
  fi
else
  print_info "Zoxide is already installed"
fi

# Install eza (modern ls replacement)
if ! command -v eza &>/dev/null; then
  print_info "Installing eza..."
  case $PKG_MANAGER in
  "apt")
    # Add eza repository for Ubuntu/Debian
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | $SUDO gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | $SUDO tee /etc/apt/sources.list.d/gierens.list
    $SUDO chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    $SUDO apt update
    if $SUDO apt install -y eza; then
      print_success "Installed eza"
    else
      print_warning "Failed to install eza via repository"
      failed_packages+=("eza")
    fi
    ;;
  *)
    # Try cargo install as fallback
    if command -v cargo &>/dev/null; then
      if cargo install eza; then
        print_success "Installed eza via cargo"
      else
        print_warning "Failed to install eza via cargo"
        failed_packages+=("eza")
      fi
    else
      print_warning "Cargo not available, skipping eza installation"
      failed_packages+=("eza")
    fi
    ;;
  esac
else
  print_info "Eza is already installed"
fi

# Install Node.js tooling
install_node_ecosystem

# Install thefuck (command corrector)
if ! command -v thefuck &>/dev/null; then
  print_info "Installing thefuck..."
  if pip3 install --user thefuck; then
    print_success "Installed thefuck"
    print_info "Adding ~/.local/bin to PATH for current session..."
    export PATH="$HOME/.local/bin:$PATH"
  else
    print_warning "Failed to install thefuck"
    failed_packages+=("thefuck")
  fi
else
  print_info "Thefuck is already installed"
fi

# Report any failed packages
if [ ${#failed_packages[@]} -gt 0 ]; then
  print_warning "The following packages failed to install:"
  for package in "${failed_packages[@]}"; do
    printf "  - %s\n" "$package"
  done
  print_info "You may need to install these manually"
fi

# Final instructions
print_success "🎉 Linux setup completed!"
print_info "Next steps:"
print_info "1. Restart your terminal to load new PATH and shell configurations"
print_info "2. Run: source ~/.bashrc && source ~/.zshrc"
print_info "3. Run: ./bootstrap.sh to install the dotfiles"
print_info "4. Enjoy your enhanced terminal experience!"

# Additional setup notes
print_info ""
print_info "📝 Additional setup notes:"
print_info "• Miniconda has been installed and configured"
print_info "• NVM has been installed with the latest LTS Node.js"
print_info "• Python packages can be installed via pip3 or conda"
print_info "• Node.js packages can be managed via npm, yarn, pnpm, or bun"

# Check if any critical tools are missing
critical_tools=("git" "zsh" "python3" "curl" "wget")
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
else
  print_success "All critical tools are installed!"
fi
