#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")"

function doIt() {
    printf "\e[33m%s\e[0m\n" "# Updating nvim configs..."
    rsync --exclude ".git/" \
        --exclude ".DS_Store" \
        --exclude "bootstrap.sh" \
        -avh --no-perms . ~/.config/nvim
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
