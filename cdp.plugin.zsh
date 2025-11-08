# Path to the configuration file for storing PROJECTS_DIR within the plugin folder
CDP_CONFIG_FILE="${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/cdp/.cdp_config"

# Default directory if no configuration is found
PROJECTS_DIR=~/dev/sites

_cdp_expand_path() {
  local path="$1"
  case "$path" in
    "~"|"~/"*)
      printf '%s\n' "${path/#\~/$HOME}"
      ;;
    *)
      printf '%s\n' "$path"
      ;;
  esac
}

# Load config once at plugin load
if [ -f "$CDP_CONFIG_FILE" ]; then
  source "$CDP_CONFIG_FILE"
fi

# Define the cdp function
cdp() {
  local expanded_projects_dir
  expanded_projects_dir="$(_cdp_expand_path "$PROJECTS_DIR")"

  # Check for the --folder flag
  if [[ "$1" == "--folder" && -n "$2" ]]; then
    # Set the PROJECTS_DIR to the provided folder and save it in the plugin folder
    PROJECTS_DIR="$2"
    echo "export PROJECTS_DIR=\"$PROJECTS_DIR\"" > "$CDP_CONFIG_FILE"
    echo "PROJECTS_DIR set to: $PROJECTS_DIR"
    return 0
  fi

  # If no project name was provided, try to detect the current project root
  if [ -z "$1" ]; then
    local current_dir="$PWD"

    if [[ "$current_dir" == "$expanded_projects_dir" ]]; then
      echo "Already at projects directory: $expanded_projects_dir"
      return 0
    fi

    if [[ "$current_dir" == "$expanded_projects_dir"/* ]]; then
      local relative_path="${current_dir#$expanded_projects_dir/}"
      local project="${relative_path%%/*}"
      if [[ -n "$project" ]]; then
        cd "$expanded_projects_dir/$project"
        return $?
      fi
    fi

    echo "Usage: cdp [--folder <directory>] <project-name>"
    return 1
  fi

  # Navigate to the project directory
  cd "$expanded_projects_dir/$1" 2>/dev/null || echo "Project '$1' not found in '$PROJECTS_DIR'."
}

# Autocomplete function using Zsh's completion system
_cdp_complete() {
  local curcontext="$curcontext" state line
  typeset -A opt_args

  _arguments \
    '--folder[Set projects directory]:directory:_path_files -/' \
    '*:project:->projects'

  case $state in
    projects)
      # Use Zsh's globbing and parameter expansion instead of external commands
      local -a dirs
      local expanded_projects_dir="$(_cdp_expand_path "$PROJECTS_DIR")"
      dirs=("${(@)${(@f)$(print -l $expanded_projects_dir/*(/N:t))}}")
      _describe 'projects' dirs
      ;;
  esac
}

# Register the completion function
compdef _cdp_complete cdp
