# Platform-specific configurations
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS with Homebrew
  eval "$(/opt/homebrew/bin/brew shellenv)"

  # >>> conda initialize >>>
  # !! Contents within this block are managed by 'conda init' !!
  __conda_setup="$('/opt/miniconda3/bin/conda' 'shell.bash' 'hook' 2>/dev/null)"
  if [ $? -eq 0 ]; then
    eval "$__conda_setup"
  else
    if [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
      . "/opt/miniconda3/etc/profile.d/conda.sh"
    else
      export PATH="/opt/miniconda3/bin:$PATH"
    fi
  fi
  unset __conda_setup
  # <<< conda initialize <<<

  # Ensure conda paths are at the front of PATH after brew shellenv
  export PATH="/opt/miniconda3/bin:/opt/miniconda3/condabin:$PATH"

  # zsh-autosuggestions
  source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

  # zsh-syntax-highlighting
  source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

  # Icons in terminal
  source ~/.local/share/icons-in-terminal/icons_bash.sh

  # fzf
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  # Linux configurations

  # Make Tab autocomplete regardless of filename case
  set completion-ignore-case on

  # List all matches in case multiple possible completions are possible
  set show-all-if-ambiguous on

  # zsh-autosuggestions (common locations)
  if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  elif [ -f ~/.local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source ~/.local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  fi

  # zsh-syntax-highlighting (common locations)
  if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  elif [ -f ~/.local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source ~/.local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  fi

  # fzf (common locations)
  if [ -f ~/.fzf.zsh ]; then
    source ~/.fzf.zsh
  elif [ -f /usr/share/fzf/key-bindings.zsh ]; then
    source /usr/share/fzf/key-bindings.zsh
    source /usr/share/fzf/completion.zsh
  fi
fi

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,exports,aliases,functions,extra,extend}; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

# Initialize zoxide
if command -v zoxide &>/dev/null; then
  if [[ "$SHELL" == */zsh ]]; then
    eval "$(zoxide init zsh)"
  elif [[ "$SHELL" == */bash ]]; then
    eval "$(zoxide init bash)"
  fi
fi

# Initialize Starship prompt
if command -v starship &>/dev/null; then
  if [[ "$SHELL" == */zsh ]]; then
    eval "$(starship init zsh)"
  elif [[ "$SHELL" == */bash ]]; then
    eval "$(starship init bash)"
  fi
else
  # Fallback to custom prompt if Starship is not available
  [ -r ~/.bash_prompt ] && [ -f ~/.bash_prompt ] && source ~/.bash_prompt
fi

# Enter tmux on start
if command -v tmux &>/dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ] && [[ ! "$TERM_PROGRAM" == "vscode" ]]; then
  tmux new-session -A -s main
fi
