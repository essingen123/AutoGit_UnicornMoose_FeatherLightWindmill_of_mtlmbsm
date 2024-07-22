#!/bin/bash

# .bashrc update
update_bashrc() {
    local entry="$1"
    local file="$HOME/.bashrc"
    log "Updating .bashrc with entry: $entry"

    if ! grep -qF "$entry" "$file"; then
        echo "$entry" >> "$file"
        log "Added $entry to $file"
    else
        log "$entry already exists in $file"
    fi
}

add_alias_to_bashrc() {
    local alias_cmd="alias g='${script_path}'"
    log "Adding alias to .bashrc: $alias_cmd"
    update_bashrc "$alias_cmd"
    log "Alias 'g' added to .bashrc. Please restart your terminal or source ~/.bashrc."
}

check_github_token() {
    local token_file="$HOME/.git_very_secret_and_ignored_file_token"
    if [ ! -f "$token_file" ]; then
        log "GitHub token not found in your environment."
        read -p "Would you like to enter your GitHub token? (It will be saved in a hidden file for future sessions) (y/n) " yn
        if [[ "$yn" == "y" ]]; then
            read -s -p "Enter your GitHub token: " token
            echo
            echo "$token" > "$token_file"
            chmod 600 "$token_file"
            log "GitHub token set for this session and saved for future sessions."
        else
            log "GitHub token is required. Exiting."
            exit 1
        fi
    else
        log "GitHub token is already set."
    fi
}
