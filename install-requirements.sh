#!/bin/bash

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

# Install brew if it is mac
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS

    # If brew command does not exist
    if ! command -v brew; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # Install requirements
    for r in "${req[@]}"; do
        if ! brew ls -v "$r" >/dev/null; then
            brew install "$r"
        fi
    done

    # Install cask linearmouse
    if ! brew ls -v "linearmouse"; then
        brew install --cask linearmouse
    fi
fi

# Install bun
if ! command -v bun; then
    curl -fsSL https://bun.sh/install | bash
fi
