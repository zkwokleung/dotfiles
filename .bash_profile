# Mac only
if [[ "$OSTYPE" == "darwin"* ]]; then
  # Homebrew
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Environment Variables
export JSON_JAVA=$HOME/Library/JSON
export CLASSPATH=$CLASSPATH:$JSON_JAVA/json-simple-1.1.1.jar

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra,zshrc,inputrc}; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

# Icons in terminal
source ~/.local/share/icons-in-terminal/icons_bash.sh

# Enter tmux on start
if command -v tmux &>/dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  tmux new-session -A -s main
fi
