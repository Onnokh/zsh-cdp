# Ensure PROJECTS_DIR is set
PROJECTS_DIR=~/dev/sites

# Define the cdp function
cdp() {
  if [ -z "$1" ]; then
    echo "Usage: cdp <project-name>"
    return 1
  fi
  cd "$PROJECTS_DIR/$1" 2>/dev/null || echo "Project '$1' not found."
}

# Autocomplete function using Zsh's completion system
_cdp_complete() {
  local word
  word="${COMP_WORDS[1]}"
  COMPREPLY=($(compgen -W "$(ls "$PROJECTS_DIR")" -- "$word"))
}

# Use Zsh's newer completion system
_cdp_zsh_complete() {
  compadd $(ls "$PROJECTS_DIR")
}

# Register the completion function
compdef _cdp_zsh_complete cdp

