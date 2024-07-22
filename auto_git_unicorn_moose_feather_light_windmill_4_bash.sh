#!/bin/bash

# Main script to orchestrate other scripts
# Include other scripts
source ./config_handler.sh
source ./error_handler.sh
source ./github_setup.sh
source ./git_operations.sh
source ./bashrc_update.sh

# Function to check and add alias
check_and_add_alias() {
    local alias_cmd="alias g='${script_path}'"
    if ! type g >/dev/null 2>&1; then
        if ! grep -qF "$alias_cmd" "$HOME/.bashrc"; then
            echo "$alias_cmd" >> "$HOME/.bashrc"
            log "Alias 'g' added to .bashrc. Please restart your terminal or source ~/.bashrc."
        else
            log "Alias 'g' already exists in .bashrc."
        fi
    else
        log "Alias 'g' is already defined in the system."
    fi
}

# Main script logic
read_config
if [ ! -d ".git" ]; then
    log "Git is not initialized. Proceeding to setup the repository."
    setup_github_repo
else
    log "Git is already initialized."
    if [ "$update_flag" == "y" ]; then
        log "Update flag is set to 'y'. Proceeding to setup the repository."
        setup_github_repo
    else
        log "Update flag set to 'n'. Syncing repository."
        sync_github_repo
    fi
fi

if [ "$auto_page_trigger" = true ] || [ ! -f "index.html" ]; then
    log "index.html not found or auto page generation enabled. Generating HTML page from README.md..."
    generate_html_page
else
    log "If you wish to also have that cool HTML page, you can run the following command to generate a neat webpage for your GitHub project: ./_extra_bonus.py"
fi

update_github_about

# Check and add alias
check_and_add_alias
