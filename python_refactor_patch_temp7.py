import os
import stat

# Function to write the contents to a file
def write_file(file_path, content):
    with open(file_path, 'w') as f:
        f.write(content)

# Function to set executable permissions
def set_executable(file_path):
    st = os.stat(file_path)
    os.chmod(file_path, st.st_mode | stat.S_IEXEC)

# Contents of auto_git_unicorn_moose_feather_light_windmill_4_bash.sh
entry_script_content = '''#!/bin/bash

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
'''

# Contents of config_handler.sh
config_handler_content = '''#!/bin/bash

# Configuration handler
read_config() {
    config_file="${script_dir}/kigit.txt"
    update_flag="n"
    repo_name="random"
    public="n"
    auto_page="n"
    tags=""
    description=""
    website=""
    verbose="n"
    branch="main"
    commit_message="Syncing changes with GitHub"

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
                *"set303j"*)
                    read -r next_line
                    branch="${next_line}"
                    ;;
                *"set303k"*)
                    read -r next_line
                    commit_message="${next_line}"
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
y

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
y

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

# 🎉
# GithubPartywebpageLink
# set303h
index.html

# 💬
# Verbose, output for each terminal run, y for yes and n for no
# set303i
n

# 🌳
# Branch to commit to, 'main' or a new branch name
# set303j
main

# 💬
# Default commit message
# set303k
This is my standard commit message to save time: Hmm.. just look at the data to reveal the updates

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
'''

# Contents of error_handler.sh
error_handler_content = '''#!/bin/bash

handle_error() {
    local error_message="$1"
    echo "Error: $error_message"
    exit 1
}
'''

# Contents of github_setup.sh
github_setup_content = '''#!/bin/bash

# GitHub setup operations
setup_github_repo() {
    local dir="$1"
    add_alias_to_bashrc
    check_github_token

    # Initialize git if not already initialized
    if [ ! -d "$dir/.git" ]; then
        git init "$dir"
        log "Git repository initialized."
    fi

    # Create or update .gitignore
    if [ ! -f "$dir/.gitignore" ]; then
        log "No .gitignore file found. Creating one."
        touch "$dir/.gitignore"
        echo "# Ignore OS-specific files" >> "$dir/.gitignore"
        echo ".DS_Store" >> "$dir/.gitignore"
        echo "Thumbs.db" >> "$dir/.gitignore"

        echo "# Ignore IDE files" >> "$dir/.gitignore"
        echo "*.iml" >> "$dir/.gitignore"
        echo ".idea" >> "$dir/.gitignore"
        echo ".vscode" >> "$dir/.gitignore"

        echo "# Ignore sensitive files" >> "$dir/.gitignore"
        echo ".env" >> "$dir/.gitignore"
        echo "*.pem" >> "$dir/.gitignore"
        echo ".git_very_secret_and_ignored_file_token" >> "$dir/.gitignore"

        echo "# Ignore log and build files" >> "$dir/.gitignore"
        echo "*.log" >> "$dir/.gitignore"
        echo "build/" >> "$dir/.gitignore"
        echo "dist/" >> "$dir/.gitignore"
        echo "*.o" >> "$dir/.gitignore"
        echo "*.exe" >> "$dir/.gitignore"
        echo "*.dll" >> "$dir/.gitignore"
        echo "*.so" >> "$dir/.gitignore"

        git add "$dir/.gitignore"
        git commit -m "Add .gitignore" -C "$dir"
    else
        if ! grep -q ".git_very_secret_and_ignored_file_token" "$dir/.gitignore"; then
            echo ".git_very_secret_and_ignored_file_token" >> "$dir/.gitignore"
            git add "$dir/.gitignore"
            git commit -m "Update .gitignore to include .git_very_secret_and_ignored_file_token" -C "$dir"
        fi
    fi

    # Check if the repository already exists on GitHub
    repo_exists=$(gh repo view "$repo_name" --json name --jq '.name' 2>/dev/null)
    if [ -z "$repo_exists" ]; then
        gh repo create "$repo_name" $visibility --enable-issues --enable-wiki
    else
        log "Repository already exists. Fetching current description."
        current_description=$(gh api repos/"$github_username"/"$repo_name" --jq .description)
        if [ -n "$current_description" ] && ! grep -q "set303f description" "$config_file"; then
            echo "set303f description=$current_description" >> "$config_file"
            log "Updated kigit.txt with current repository description."
        fi
    fi

    # Add all files and commit
    git add .
    git commit -m "$commit_message" -C "$dir"
    git push --set-upstream origin "$branch" -C "$dir"
    git push origin "$branch" -C "$dir"
}
'''

# Contents of git_operations.sh
git_operations_content = '''#!/bin/bash

# Git operations
sync_github_repo() {
    local dir="$1"
    git add .
    git commit -m "$commit_message" -C "$dir"
    git push origin "$branch" -C "$dir"
}

generate_html_page() {
    local dir="$1"
    log "Generating HTML page from README.md..."
    python3 "${script_dir}/_extra_bonus.py"
}

update_github_about() {
    local dir="$1"
    python3 "${script_dir}/update_github_about.py"
}
'''

# Contents of bashrc_update.sh
bashrc_update_content = '''#!/bin/bash

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
'''

# Write the contents to respective files
write_file('auto_git_unicorn_moose_feather_light_windmill_4_bash.sh', entry_script_content)
write_file('config_handler.sh', config_handler_content)
write_file('error_handler.sh', error_handler_content)
write_file('github_setup.sh', github_setup_content)
write_file('git_operations.sh', git_operations_content)
write_file('bashrc_update.sh', bashrc_update_content)

# Set the permissions to executable
set_executable('auto_git_unicorn_moose_feather_light_windmill_4_bash.sh')
set_executable('config_handler.sh')
set_executable('error_handler.sh')
set_executable('github_setup.sh')
set_executable('git_operations.sh')
set_executable('bashrc_update.sh')

print("Scripts have been generated successfully.")
