#!/usr/bin/env bash

# Exit on any error
set -e

cd "$(dirname "${BASH_SOURCE}")"

function doIt() {
    printf "\e[33m%s\e[0m\n" "# Updating dotfiles..."

    # Copy main dotfiles, but include the shell config files
    rsync --exclude ".git/" \
        --exclude ".DS_Store" \
        --exclude ".osx" \
        --exclude "bootstrap.sh" \
        --exclude "README.md" \
        --exclude "LICENSE-MIT.txt" \
        --exclude ".tmux.conf.local" \
        --exclude ".gitmux.yaml" \
        --exclude ".trunk" \
        --exclude "setup.sh" \
        -avh --no-perms . ~ || {
        printf "\e[31m%s\e[0m\n" "Error: Failed to copy dotfiles"
        exit 1
    }

    printf "\e[33m%s\e[0m\n" "# Updating tmux configuration..."

    # Create tmux config directory if it doesn't exist
    mkdir -p ~/.config/tmux || {
        printf "\e[31m%s\e[0m\n" "Error: Failed to create tmux config directory"
        exit 1
    }

    # Copy tmux configuration files
    rsync -avh .tmux.conf.local ~/.config/tmux/tmux.conf.local || {
        printf "\e[31m%s\e[0m\n" "Error: Failed to copy tmux.conf.local"
        exit 1
    }

    rsync -avh .gitmux.yaml ~/.config/tmux/gitmux.conf || {
        printf "\e[31m%s\e[0m\n" "Error: Failed to copy gitmux.yaml"
        exit 1
    }

    printf "\e[33m%s\e[0m\n" "# Configuring git..."

    # Configure git colors
    git config --global color.ui true

    git config --global color.diff-highlight.oldNormal "red bold"
    git config --global color.diff-highlight.oldHighlight "red bold 52"
    git config --global color.diff-highlight.newNormal "green bold"
    git config --global color.diff-highlight.newHighlight "green bold 22"

    git config --global color.diff.meta "11"
    git config --global color.diff.frag "magenta bold"
    git config --global color.diff.func "146 bold"
    git config --global color.diff.commit "yellow bold"
    git config --global color.diff.old "red bold"
    git config --global color.diff.new "green bold"
    git config --global color.diff.whitespace "red reverse"

    # Configure diff-so-fancy only if it's installed
    if command -v diff-so-fancy >/dev/null 2>&1; then
        printf "\e[33m%s\e[0m\n" "# Configuring diff-so-fancy..."
        git config --global core.pager "diff-so-fancy | less --tabs=4 -RF"
        git config --global interactive.diffFilter "diff-so-fancy --patch"
    else
        printf "\e[33m%s\e[0m\n" "# diff-so-fancy not found, skipping pager configuration"
        printf "\e[33m%s\e[0m\n" "# Run 'brew install diff-so-fancy' to enable enhanced git diffs"
    fi

    printf "\e[32m%s\e[0m\n" "✅ Dotfiles installation completed successfully!"
    printf "\e[33m%s\e[0m\n" "📝 Please restart your terminal or run 'source ~/.zshrc' to apply changes"
}

if { [ "$1" == "--force" ] || [ "$1" == "-f" ]; }; then
    doIt
else
    read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        doIt
    fi
fi
unset doIt
