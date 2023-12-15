# Mac only
if [[ "$OSTYPE" == "darwin"* ]]; then
  # Homebrew
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra,inputrc}; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

# Icons in terminal
source ~/.local/share/icons-in-terminal/icons_bash.sh

# zsh-autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# zsh-syntax-highlighting
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Enter tmux on start
if command -v tmux &>/dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  tmux new-session -A -s main
fi
