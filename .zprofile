# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Environment Variables
export JSON_JAVA=$HOME/Library/JSON
export CLASSPATH=$CLASSPATH:$JSON_JAVA/json-simple-1.1.1.jar

# Load alias file
if [ -f ~/.zaliases ]; then
  . ~/.zaliases
fi

# Load functions file
if [ -f ~/.zfunctions ]; then
  . ~/.zfunctions
fi

# Enter tmux on start
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux new-session -A -s main
fi
