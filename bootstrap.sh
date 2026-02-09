#!/usr/bin/env bash

# Exit on any error
set -e

cd "$(dirname "${BASH_SOURCE}")"

function doIt() {
  printf "\e[33m%s\e[0m\n" "# Updating dotfiles..."

  # List of files/directories to exclude from symlinking
  EXCLUDES=(
    "." ".." ".git" ".DS_Store" ".osx" "bootstrap.sh" "README.md" "LICENSE-MIT.txt"
    ".tmux.conf.local" ".gitmux.yaml" "starship.toml" ".vscode" ".config" ".trunk"
    "setup.sh" "health-check.sh" "setup-*.sh"
  )

  for src in .* *; do
    skip=false
    for exclude in "${EXCLUDES[@]}"; do
      if [[ "$src" == "$exclude" ]]; then
        skip=true
        break
      fi
    done
    if $skip; then
      continue
    fi
    dest="$HOME/$src"
    # If destination exists and is not a symlink to the same file, back it up
    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
      mv "$dest" "$dest.bak"
      printf "\e[33m%s\e[0m\n" "Backed up $dest to $dest.bak"
    elif [ -L "$dest" ]; then
      rm "$dest"
    fi
    ln -sfn "$PWD/$src" "$dest"
    printf "\e[32m%s\e[0m\n" "Linked $src -> $dest"
  done

  printf "\e[33m%s\e[0m\n" "# Updating tmux configuration..."

  # Create tmux config directory if it doesn't exist
  mkdir -p ~/.config/tmux || {
    printf "\e[31m%s\e[0m\n" "Error: Failed to create tmux config directory"
    exit 1
  }

  # Symlink tmux configuration files
  for pair in ".tmux.conf.local:~/.config/tmux/tmux.conf.local" ".gitmux.yaml:~/.config/tmux/gitmux.conf"; do
    src="${pair%%:*}"
    dest="${pair##*:}"
    # Expand ~ in dest
    eval dest="$dest"
    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
      mv "$dest" "$dest.bak"
      printf "\e[33m%s\e[0m\n" "Backed up $dest to $dest.bak"
    elif [ -L "$dest" ]; then
      rm "$dest"
    fi
    ln -sfn "$PWD/$src" "$dest"
    printf "\e[32m%s\e[0m\n" "Linked $src -> $dest"
  done

  # Symlink Starship configuration
  if [ -f starship.toml ]; then
    dest="$HOME/.config/starship.toml"
    mkdir -p "$HOME/.config"
    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
      mv "$dest" "$dest.bak"
      printf "\e[33m%s\e[0m\n" "Backed up $dest to $dest.bak"
    elif [ -L "$dest" ]; then
      rm "$dest"
    fi
    ln -sfn "$PWD/starship.toml" "$dest"
    printf "\e[32m%s\e[0m\n" "Linked starship.toml -> $dest"
  else
    printf "\e[33m%s\e[0m\n" "# starship.toml not found, skipping Starship configuration"
  fi

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
    if [[ "$OSTYPE" == "darwin"* ]]; then
      printf "\e[33m%s\e[0m\n" "# Run 'brew install diff-so-fancy' to enable enhanced git diffs"
    else
      printf "\e[33m%s\e[0m\n" "# Install diff-so-fancy using your package manager to enable enhanced git diffs"
    fi
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
