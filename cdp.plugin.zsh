# Path to the configuration file for storing PROJECTS_DIR within the plugin folder
CDP_CONFIG_FILE="${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/cdp/.cdp_config"

# Load the PROJECTS_DIR from the config file if it exists
if [ -f "$CDP_CONFIG_FILE" ]; then
  source "$CDP_CONFIG_FILE"
else
  # Default directory if no configuration is found
  PROJECTS_DIR=~/dev/sites
fi

# Define the cdp function
cdp() {
  # Check for the --folder flag
  if [[ "$1" == "--folder" && -n "$2" ]]; then
    # Set the PROJECTS_DIR to the provided folder and save it in the plugin folder
    PROJECTS_DIR="$2"
    echo "export PROJECTS_DIR=\"$PROJECTS_DIR\"" > "$CDP_CONFIG_FILE"
    echo "PROJECTS_DIR set to: $PROJECTS_DIR"
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
  local word
  # Ensure PROJECTS_DIR is updated with the current value
  source "$CDP_CONFIG_FILE"

  word="${COMP_WORDS[1]}"

  # Get only the last part of the folder name
  local project_dirs
  project_dirs=($(ls -d $PROJECTS_DIR/*/))

  # Extract only the last part (folder names) and use compadd
  local folder_names=()
  for dir in $project_dirs; do
    folder_names+=($(basename "$dir"))
  done

  # Use compadd to provide the folder names as autocomplete options
  compadd "${folder_names[@]}"
}

# Register the completion function
compdef _cdp_complete cdp
