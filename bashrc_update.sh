#!/bin/bash

# Function to update .bashrc with new alias or environment variable
update_bashrc() {
    local entry="$1"
    local file="$HOME/.bashrc"

    if ! grep -qF "$entry" "$file"; then
        echo "$entry" >> "$file"
        echo "Added $entry to $file"
    else
        echo "$entry already exists in $file"
    fi
}

# Check and add alias to .bashrc
add_alias_to_bashrc() {
    local alias_cmd="alias g='${script_path}'"
    update_bashrc "$alias_cmd"
    echo "Alias 'g' added to .bashrc. Please restart your terminal or source ~/.bashrc."
}

# Prompt for GitHub token and update a hidden file if needed
check_github_token() {
    local token_file="$HOME/.git_very_secret_and_ignored_file_token"
    if [ ! -f "$token_file" ]; then
        echo "GitHub token not found in your environment."
        read -p "Would you like to enter your GitHub token? (It will be saved in a hidden file for future sessions) (y/n) " yn
        if [[ "$yn" == "y" ]]; then
            read -s -p "Enter your GitHub token: " token
            echo
            echo "$token" > "$token_file"
            chmod 600 "$token_file"
            echo "GitHub token set for this session and saved for future sessions."
        else
            echo "GitHub token is required. Exiting."
            exit 1
        fi
    else
        echo "GitHub token is already set."
    fi
}
