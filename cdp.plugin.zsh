# Path to the configuration file for storing PROJECTS_DIR within the plugin folder
CDP_CONFIG_FILE="${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/cdp/.cdp_config"

# Default directory if no configuration is found
PROJECTS_DIR=~/dev/sites

# Cache for project directories
typeset -g _CDP_PROJECT_CACHE
typeset -g _CDP_CACHE_TIMESTAMP

# Load config once at plugin load
if [ -f "$CDP_CONFIG_FILE" ]; then
  source "$CDP_CONFIG_FILE"
fi

# Function to refresh project cache
_cdp_refresh_cache() {
  _CDP_PROJECT_CACHE=("${(@)${(@f)$(print -l $PROJECTS_DIR/*(/N:t))}}")
  _CDP_CACHE_TIMESTAMP=$EPOCHSECONDS
}

# Define the cdp function
cdp() {
  # Check for the --folder flag
  if [[ "$1" == "--folder" && -n "$2" ]]; then
    # Set the PROJECTS_DIR to the provided folder and save it in the plugin folder
    PROJECTS_DIR="$2"
    echo "export PROJECTS_DIR=\"$PROJECTS_DIR\"" > "$CDP_CONFIG_FILE"
    echo "PROJECTS_DIR set to: $PROJECTS_DIR"
    # Refresh cache when directory changes
    _cdp_refresh_cache
    return 0
  fi

  # Ensure the project name is provided
  if [ -z "$1" ]; then
    echo "Usage: cdp [--folder <directory>] <project-name>"
    return 1
  fi

  # Navigate to the project directory
  cd "$PROJECTS_DIR/$1" 2>/dev/null || echo "Project '$1' not found in '$PROJECTS_DIR'."
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
      # Refresh cache if it's older than 5 minutes or empty
      if [[ -z $_CDP_PROJECT_CACHE || $((EPOCHSECONDS - _CDP_CACHE_TIMESTAMP)) -gt 300 ]]; then
        _cdp_refresh_cache
      fi
      _describe 'projects' _CDP_PROJECT_CACHE
      ;;
  esac
}

# Register the completion function
compdef _cdp_complete cdp

# Initialize cache
_cdp_refresh_cache
