#!/bin/bash

# Main script to orchestrate other scripts
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
current_dir="$(pwd)"

source "$script_dir/config_handler.sh"
source "$script_dir/error_handler.sh"
source "$script_dir/github_setup.sh"
source "$script_dir/git_operations.sh"
source "$script_dir/bashrc_update.sh"

# Main script logic
read_config "$current_dir/kigit.txt"

if [ ! -d "$current_dir/.git" ]; then
    log "Git is not initialized. Proceeding to setup the repository."
    setup_github_repo "$current_dir"
else
    log "Git is already initialized."
    if [ "$update_flag" == "y" ]; then
        log "Update flag is set to 'y'. Proceeding to setup the repository."
        setup_github_repo "$current_dir"
    else
        log "Update flag set to 'n'. Syncing repository."
        sync_github_repo "$current_dir"
    fi
fi

if [ "$auto_page_trigger" = true ] || [ ! -f "$current_dir/index.html" ]; then
    log "index.html not found or auto page generation enabled. Generating HTML page from README.md..."
    generate_html_page "$current_dir"
else
    log "If you wish to also have that cool HTML page, you can run the following command to generate a neat webpage for your GitHub project: ./_extra_bonus.py"
fi

update_github_about "$current_dir"
