# Used for interactive Bash shells.

[[ $- != *i* ]] && return

# Icons in terminal.
[ -f ~/.local/share/icons-in-terminal/icons_bash.sh ] && source ~/.local/share/icons-in-terminal/icons_bash.sh

# fzf (bash keybindings + completion).
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# zoxide.
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init bash)"
fi

# Starship prompt fallback to bash prompt.
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init bash)"
else
  [ -r ~/.bash_prompt ] && [ -f ~/.bash_prompt ] && source ~/.bash_prompt
fi

# Shared interactive setup.
[ -f ~/.shellrc ] && source ~/.shellrc
