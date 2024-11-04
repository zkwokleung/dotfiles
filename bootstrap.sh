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
        --exclude "install-requirements.sh" \
        -avh --no-perms . ~

    printf "\e[33m%s\e[0m\n" " # Updating tmux.conf.local..."
    rsync -avh .tmux.conf.local ~/.config/tmux/tmux.conf.local
    rsync -avh .gitmux.yaml ~/.config/tmux/gitmux.conf

    # Config diff-so-fancy
    git config --global core.pager "diff-so-fancy | less --tabs=4 -RF"
    git config --global interactive.diffFilter "diff-so-fancy --patch"

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
}

if { [ "$1" == "--force" ] || [ "$1" == "-f" ];  } then
    doIt
else
    read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        doIt
    fi
fi
unset doIt
