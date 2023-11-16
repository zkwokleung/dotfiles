#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")"

function doIt() {
    rsync --exclude ".git/" \
        --exclude ".DS_Store" \
        --exclude ".osx" \
        --exclude "bootstrap.sh" \
        --exclude "README.md" \
        --exclude "LICENSE-MIT.txt" \
        --exclude ".bashrc" \
        --exclude ".zprofile" \
        -avh --no-perms . ~

    # determine if the OS is macOS or linux
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        cp .zprofile ~/.zprofile
        source ~/.zprofile
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