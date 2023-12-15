#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")"

function doIt() {
    printf "\e[33m%s\e[0m\n" "# Updating dotfiles..."
    rsync --exclude ".git/" \
        --exclude ".DS_Store" \
        --exclude ".osx" \
        --exclude "bootstrap.sh" \
        --exclude "README.md" \
        --exclude "LICENSE-MIT.txt" \
        --exclude "PowerShell" \
        --exclude ".bashrc" \
        --exclude ".zshrc" \
        --exclude ".zprofile" \
        --exclude ".tmux.conf.local" \
        --exclude ".gitmux.yaml" \
        --exclude "vim" \
        --exclude ".trunk" \
        -avh --no-perms . ~

    printf "\e[33m%s\e[0m\n" " # Updating tmux.conf.local..."
    rsync -avh .tmux.conf.local ~/.config/tmux/tmux.conf.local
    rsync -avh .gitmux.yaml ~/.config/tmux/gitmux.conf

    # determine if the OS is macOS or linux
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        cp .zprofile ~/.zshrc
        source ~/.zshrc
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        cp .bashrc ~/.bashrc
        source ~/.bashrc
    fi
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
    doIt
else
    read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        doIt
    fi
fi
unset doIt
