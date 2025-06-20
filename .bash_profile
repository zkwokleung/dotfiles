# Mac only
if [[ "$OSTYPE" == "darwin"* ]]; then
    # Homebrew
    eval "$(/opt/homebrew/bin/brew shellenv)"

    # zsh-autosuggestions
    source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

    # zsh-syntax-highlighting
    source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

    # Icons in terminal
    source ~/.local/share/icons-in-terminal/icons_bash.sh

    # fzf
    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
fi

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,exports,aliases,functions,extra,inputrc,extend}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

# Initialize zoxide
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
fi

# Initialize Starship prompt
if command -v starship &>/dev/null; then
    eval "$(starship init zsh)"
else
    # Fallback to custom prompt if Starship is not available
    [ -r ~/.bash_prompt ] && [ -f ~/.bash_prompt ] && source ~/.bash_prompt
fi

# Enter tmux on start
if command -v tmux &>/dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ] && [[ ! "$TERM_PROGRAM" == "vscode" ]]; then
    tmux new-session -A -s main
fi

eval $(thefuck --alias)
