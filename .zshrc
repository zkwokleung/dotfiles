# Used for interactive zsh shells.

[[ -o interactive ]] || return

# zsh-completions path.
if command -v brew >/dev/null 2>&1; then
  export FPATH="$(brew --prefix)/share/zsh-completions:$FPATH"
fi

# Use emacs keybindings instead of vi mode.
bindkey -e

# zsh-autosuggestions.
if command -v brew >/dev/null 2>&1 && [ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
elif [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [ -f ~/.local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source ~/.local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# zsh-syntax-highlighting.
if command -v brew >/dev/null 2>&1 && [ -f "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
  source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
elif [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [ -f ~/.local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source ~/.local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# fzf (zsh keybindings + completion).
if [ -f ~/.fzf.zsh ]; then
  source ~/.fzf.zsh
elif [ -f /usr/share/fzf/key-bindings.zsh ]; then
  source /usr/share/fzf/key-bindings.zsh
  [ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh
fi

# zoxide.
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# Starship prompt fallback to bash prompt.
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
else
  [ -r ~/.bash_prompt ] && [ -f ~/.bash_prompt ] && source ~/.bash_prompt
fi

# Shared interactive setup.
[ -f ~/.shellrc ] && source ~/.shellrc
