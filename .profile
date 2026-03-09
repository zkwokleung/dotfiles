# Shared login environment for bash/zsh.

# Platform-specific environment.
case "$OSTYPE" in
darwin*)
    if [ -x /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    # Conda base path and shell integration.
    if [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/miniconda3/etc/profile.d/conda.sh"
    fi
    export PATH="/opt/miniconda3/bin:/opt/miniconda3/condabin:$PATH"
    ;;
esac

# Load shared dotfiles.
for file in ~/.{path,exports,aliases,functions,extra,extend,extends}; do
    [ -r "$file" ] && [ -f "$file" ] && . "$file"
done
unset file
