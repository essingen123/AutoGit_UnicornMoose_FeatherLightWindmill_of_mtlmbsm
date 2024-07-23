import os

# Define the content of each script
main_script_content = """#!/bin/bash

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
"""

config_handler_content = """#!/bin/bash

# Configuration handler
read_config() {
    config_file="${1}"
    update_flag="n"
    repo_name="random"
    public="n"
    auto_page="n"
    tags=""
    description=""
    website=""
    verbose="n"

    if [ -f "$config_file" ]; then
        while IFS= read -r line; do
            case "$line" in
                *"set303a"*)
                    read -r next_line
                    update_flag="${next_line}"
                    ;;
                *"set303b"*)
                    read -r next_line
                    repo_name="${next_line}"
                    ;;
                *"set303c"*)
                    read -r next_line
                    public="${next_line}"
                    ;;
                *"set303d"*)
                    read -r next_line
                    auto_page="${next_line}"
                    ;;
                *"set303e"*)
                    read -r next_line
                    tags="${next_line}"
                    ;;
                *"set303f"*)
                    read -r next_line
                    description="${next_line}"
                    ;;
                *"set303g"*)
                    read -r next_line
                    website="${next_line}"
                    ;;
                *"set303i"*)
                    read -r next_line
                    verbose="${next_line}"
                    ;;
            esac
        done < "$config_file"
    else
        log "No kigit.txt file found. Creating default configuration file."
        cat <<EOL > "$config_file"
# This is a config file for the auto_git_unicorn_moose_feather .. 🦄
# File: kigit.txt

# 💻
# update according to this file 
# set303a 
n

# 📝# git-reponame, leave next line as random and it will be random word otherwise write a github repo name in 
# set303b
trailblazer_ai_project

# 🔒
# public git, y for yes n for no, standard no
# set303c
n

# 📄
# auto generate HTML page, y for yes n for no
# set303d
n

# 🗑️
# tags, separated by commas
# set303e
Python, Bash Clash, Bash, Automation, Automagic, un-PEP8-perhaps

# 📝
# description
# set303f
Making x less meh for those that perceives a meh really real, so the purpose of this repo is simply to make a move in the direction of a meh-factor-compensatory-instigator. x=git 💡

# 🌐
# website URL
# set303g
http://example.com

# 💬
# Verbose, output for each terminal run, y for yes and n for no
# set303i
n
# DONT EDIT OUT THIS LAST LINE
EOL
        log "Created kigit.txt. Please edit this file and re-run the script."
        exit 0
    fi

    if [ "$repo_name" == "random" ]; then
        repo_name="trailblazer_ai_project"
    fi

    if [ "$public" == "y" ]; then
        visibility="--public"
    else
        visibility="--private"
    fi

    if [ "$auto_page" == "y" ]; then
        auto_page_trigger=true
    else
        auto_page_trigger=false
    fi
}
"""

error_handler_content = """#!/bin/bash

# Error handler
log() {
    if [ "$verbose" == "y" ]; then
        echo "$1"
    fi
}
"""

github_setup_content = """#!/bin/bash

# GitHub setup
setup_github_repo() {
    local dir="$1"
    add_alias_to_bashrc
    check_github_token

    if [ ! -d "$dir/.git" ]; then
        git init "$dir"
        log "Git repository initialized."
    fi

    if [ ! -f "$dir/.gitignore" ]; then
        log "No .gitignore file found. Creating one."
        cat <<EOL > "$dir/.gitignore"
# Ignore OS-specific files
.DS_Store
Thumbs.db

# Ignore IDE files
*.iml
.idea
.vscode

# Ignore sensitive files
.env
*.pem
.git_very_secret_and_ignored_file_token

# Ignore log and build files
*.log
build/
dist/
*.o
*.exe
*.dll
*.so
EOL
        git -C "$dir" add .gitignore
        git -C "$dir" commit -m "Add .gitignore"
    fi

    repo_exists=$(gh repo view "$repo_name" --json name --jq '.name' 2>/dev/null)
    if [ -z "$repo_exists" ]; then
        gh repo create "$repo_name" $visibility --enable-issues --enable-wiki
    else
        log "Repository already exists."
    fi

    git -C "$dir" add .
    git -C "$dir" commit -m "${1:-Syncing changes with GitHub}"
    git -C "$dir" push --set-upstream origin master
    git -C "$dir" push origin master
}
"""

git_operations_content = """#!/bin/bash

# Git operations
sync_github_repo() {
    local dir="$1"
    git -C "$dir" add .
    git -C "$dir" commit -m "Syncing changes with GitHub"
    git -C "$dir" push origin master
}

generate_html_page() {
    local dir="$1"
    log "Generating HTML page from README.md..."
    python3 "$dir/_extra_bonus.py"
}

update_github_about() {
    local dir="$1"
    python3 "$dir/update_github_about.py"
}
"""

bashrc_update_content = """#!/bin/bash

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
"""

# Function to write the content to a file
def write_to_file(filename, content):
    with open(filename, 'w') as file:
        file.write(content)
    os.chmod(filename, 0o755)

# Writing all the scripts to their respective files
write_to_file('auto_git_unicorn_moose_feather_light_windmill_4_bash.sh', main_script_content)
write_to_file('config_handler.sh', config_handler_content)
write_to_file('error_handler.sh', error_handler_content)
write_to_file('github_setup.sh', github_setup_content)
write_to_file('git_operations.sh', git_operations_content)
write_to_file('bashrc_update.sh', bashrc_update_content)

print("Scripts have been generated successfully.")
