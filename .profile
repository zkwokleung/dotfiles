# Shared login environment for bash/zsh.

if [ -n "${DOTFILES_PROFILE_LOADED:-}" ]; then
    return 0 2>/dev/null || true
fi
export DOTFILES_PROFILE_LOADED=1

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
