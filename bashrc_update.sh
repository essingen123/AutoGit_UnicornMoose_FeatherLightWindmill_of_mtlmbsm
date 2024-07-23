#!/bin/bash

# Function to update .bashrc with new alias or environment variable
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

# Check and add alias to .bashrc
add_alias_to_bashrc() {
    local alias_cmd="alias g='${script_path}'"
    log "Adding alias to .bashrc: $alias_cmd"
    update_bashrc "$alias_cmd"
    log "Alias 'g' added to .bashrc. Please restart your terminal or source ~/.bashrc."
}
