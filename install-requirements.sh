#!/bin/bash

declare -a req=(
    "eza"
    "nvim"
    "tmux"
    "ast-grep"
    "fzf"
    "tree-sitter"
    "fontconfig"
    "zsh-autosuggestions"
    "zsh-syntax-highlighting"
)

# Install brew if it is mac
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS

    # If brew command does not exist
    if ! command -v brew; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    for r in "${req[@]}"
    do
        if brew ls -v "$r" > /dev/null; then
            brew install "$r"
        fi
    done
fi
