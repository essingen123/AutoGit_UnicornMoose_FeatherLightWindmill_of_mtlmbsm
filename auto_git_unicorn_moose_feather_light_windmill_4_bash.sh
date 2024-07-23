#!/bin/bash

# filename: auto_git_unicorn_moose_feather_light_windmill_4_bash.sh

# Path for the script
script_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "$0")"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to log messages if verbose is enabled
log() {
    if [ "$verbose" == "y" ]; then
        echo "$1"
    fi
}

# Include other scripts
source "$script_dir/config_handler.sh"
source "$script_dir/error_handler.sh"
source "$script_dir/github_setup.sh"
source "$script_dir/git_operations.sh"
source "$script_dir/bashrc_update.sh"

# Main script logic
read_config "$script_dir/kigit.txt"

if [ ! -d "$script_dir/.git" ]; then
    log "Git is not initialized. Proceeding to setup the repository."
    setup_github_repo "$script_dir"
else
    log "Git is already initialized."
    if [ "$update_flag" == "y" ]; then
        log "Update flag is set to 'y'. Proceeding to setup the repository."
        setup_github_repo "$script_dir"
    else
        log "Update flag set to 'n'. Syncing repository."
        sync_github_repo "$script_dir"
    fi
fi

if [ "$auto_page_trigger" = true ] || [ ! -f "$script_dir/index.html" ]; then
    log "index.html not found or auto page generation enabled. Generating HTML page from README.md..."
    generate_html_page "$script_dir"
else
    log "If you wish to also have that cool HTML page, you can run the following command to generate a neat webpage for your GitHub project: ./_extra_bonus.py"
fi

update_github_about "$script_dir"
