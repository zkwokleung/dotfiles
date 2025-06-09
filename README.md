# 🏠 zkwokleung's Dotfiles

<div align="center">

**🚀 A modern, feature-rich dotfiles collection for macOS and Unix systems**

*Transform your terminal experience with carefully crafted configurations*

[![macOS](https://img.shields.io/badge/macOS-000000?style=for-the-badge&logo=apple&logoColor=F0F0F0)](https://www.apple.com/macos/)
[![Unix](https://img.shields.io/badge/Unix-FCC624?style=for-the-badge&logo=linux&logoColor=black)](https://www.kernel.org/)
[![Zsh](https://img.shields.io/badge/Zsh-F15A24?style=for-the-badge&logo=zsh&logoColor=white)](https://www.zsh.org/)
[![Tmux](https://img.shields.io/badge/tmux-1BB91F?style=for-the-badge&logo=tmux&logoColor=white)](https://github.com/tmux/tmux)

</div>

---

## ✨ Features

### 🎯 Core Enhancements
- **🔄 Automatic tmux sessions** - Never lose your work again
- **🎨 Beautiful terminal styling** - Enhanced colors and icons with `eza`
- **⚡ Smart aliases** - 100+ time-saving command shortcuts
- **🔍 Powerful search** - Integrated `fzf` and `ag` for lightning-fast file finding
- **🤖 AI-powered CLI** - GitHub Copilot integration for command suggestions

### 🛠️ Development Tools
- **📊 Git integration** - Enhanced git workflow with custom aliases and status display
- **🔧 Multiple language support** - Optimized paths for Node.js, Python, Ruby, Flutter, and more
- **📦 Package management** - Streamlined npm, pnpm, and bun configurations
- **🎯 Smart navigation** - Quick access to common directories and projects

---

## 📁 Project Structure

```
📦 dotfiles/
├── 🔧 Core Configuration Files
│   ├── .zshrc              # Zsh main configuration
│   ├── .zprofile           # Zsh profile settings
│   ├── .bash_profile       # Bash profile (fallback)
│   ├── .bashrc             # Bash configuration
│   └── .inputrc            # Readline configuration
│
├── ⚙️ Shell Enhancements
│   ├── .aliases            # 100+ useful command aliases
│   ├── .functions          # Custom shell functions
│   ├── .exports            # Environment variables
│   └── .bash_prompt        # Custom bash prompt
│
├── 🎨 Terminal Tools
│   ├── .tmux.conf.local    # Tmux configuration
│   ├── .gitmux.yaml        # Git status in tmux bar
│   ├── .fzf.bash           # Fuzzy finder (Bash)
│   └── .fzf.zsh            # Fuzzy finder (Zsh)
│
├── 📝 Git Configuration
│   ├── .gitconfig          # Git global settings
│   └── .gitignore          # Global gitignore patterns
│
└── 🚀 Installation Scripts
    ├── setup.sh             # Environment setup & dependencies
    └── bootstrap.sh         # Main dotfiles installation
```

---

## 🚀 Quick Start

### Prerequisites
- macOS or Unix-based system
- Zsh or Bash shell
- Internet connection for dependency installation

### Installation

**1. Clone the repository**
```bash
git clone https://github.com/zkwokleung/dotfiles.git ~/Projects/dotfiles
cd ~/Projects/dotfiles
```

**2. Install dependencies (recommended)**
```bash
./setup.sh
```

**3. Apply dotfiles**
```bash
./bootstrap.sh
```

**4. Restart your terminal or reload configuration**
```bash
source ~/.zshrc  # or ~/.bash_profile for bash
```

---

## 📋 What Gets Installed

### 🔧 Essential Tools
| Tool | Purpose | Why You'll Love It |
|------|---------|-------------------|
| **eza** | Modern `ls` replacement | Beautiful file listings with icons and colors |
| **bat** | Enhanced `cat` | Syntax highlighting and git integration |
| **fzf** | Fuzzy finder | Lightning-fast file and command searching |
| **thefuck** | Command corrector | Fixes your typos automatically |
| **tmux** | Terminal multiplexer | Persistent sessions and window management |
| **ripgrep** | Fast text search | Blazingly fast grep alternative |
| **diff-so-fancy** | Git diff beautifier | Makes git diffs actually readable |

### 🎨 Shell Enhancements
- **Smart aliases** - `ll`, `la`, `..`, `...`, `p` (projects), `d` (downloads)
- **Git shortcuts** - `gs` (status), `ga` (add), `gc` (commit), `gl` (pretty log)
- **Development helpers** - `v` (nvim), `py` (python3), quick directory navigation
- **Fun utilities** - Weather display, ASCII art, loading animations

---

## 🎯 Key Features Explained

### 🔄 Automatic Tmux Integration
Every terminal session automatically starts or attaches to tmux, ensuring:
- **Session persistence** - Your work survives terminal crashes
- **Window management** - Organize your workspace efficiently
- **Git status integration** - See repository status in your status bar

### ⚡ Smart Aliases & Functions
The dotfiles include 100+ carefully crafted aliases:

```bash
# Navigation
alias ..="cd .."           # Go up one directory
alias p="cd ~/Projects"    # Jump to projects folder
alias dot="cd ~/dotfiles"  # Quick access to dotfiles

# Enhanced commands
alias ls='eza --icons'     # Beautiful file listings
alias cat='bat'            # Syntax highlighted file viewing
alias grep='rg'            # Fast text searching

# Git workflow
alias gs="git status"      # Quick status check
alias gaa="git add . && git status"  # Add all and show status
alias gl="git log --graph --pretty"  # Beautiful git history
```

### 🤖 AI-Powered CLI
Integrated GitHub Copilot CLI for intelligent command suggestions:
```bash
alias gcs="gh copilot suggest"  # Get command suggestions
alias gce="gh copilot explain"  # Explain complex commands
```

### 🎨 Enhanced Development Environment
- **Multiple language support** - Pre-configured paths for Node.js, Python, Ruby, Flutter
- **Package manager integration** - Optimized for npm, pnpm, yarn, and bun
- **Smart editor integration** - NeoVim as default editor with proper PATH setup

---

## 🔧 Customization

### Adding Your Own Aliases
Edit `.aliases` file:
```bash
# Add your custom aliases
alias myalias="your command here"
```

### Custom Functions
Add functions to `.functions`:
```bash
function myfunction() {
    # Your custom function
    echo "Hello, World!"
}
```

### Environment Variables
Modify `.exports` for custom environment setup:
```bash
export MY_CUSTOM_VAR="value"
export PATH="$PATH:/my/custom/path"
```

---

## ⚠️ Important Notes

- **Backup first**: This setup may overwrite existing configurations
- **macOS optimized**: Primarily tested on macOS, may need adjustments for other Unix systems
- **Personal preferences**: These are personal configurations - adapt them to your workflow
- **Dependencies**: Run `setup.sh` for the best experience

---

## 🤝 Contributing

Found a bug or have a suggestion? Feel free to:
1. Open an issue
2. Submit a pull request
3. Fork and customize for your needs

---

## 📄 License

This project is based on [Mathias Bynens' dotfiles](https://github.com/mathiasbynens/dotfiles) with personal modifications.

---

<div align="center">

**Happy coding! 🚀**

*Made with ❤️ for productive terminal workflows*

</div>
