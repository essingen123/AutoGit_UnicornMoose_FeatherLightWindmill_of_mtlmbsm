#!/bin/bash
# set -e  # Comment out for debugging

echo "Running file: $(basename "$0")"

script_path=$(dirname "$0")/${0##*/}
script_dir=$(dirname "$0")
config_file="$script_dir/kigit.txt"
token_file="$HOME/.git_token_secret"

log() { [ "$verbose" == "y" ] && echo "$1"; }

initialize_kigit() {
    echo "Initializing kigit configuration..."
    cat > "$config_file" <<EOL
# config file
#Update(💡)
set303a=n
#Verbose
set303i=y
#reponame(a new name makes a new repo, empty for this folders paths name)
set303b=AutoGit_UnicornMoose_FeatherLightWindmill_of_mtlmbsm
#public
set303c=n
#gen html page
set303d=y
#tags
set303e=Python, Bash Clash, Bash, Automation, Automagic, un-PEP8-perhaps
#desc
set303f=Making x less meh for those that perceives a meh really real, so the purpose of this repo is simply to make a move in the direction of a meh-factor-compensatory-instigator. x=git 
#website
set303g=
#GithubPartywebpageLink
set303h=index.html
#Branch (a new name makes a new branch)
set303j=master
#autocommit message ~date ~data is auto generating relevant things
set303k=AutoCommit, ~date ~data
# Change ownership of all files to current user
set303l=y
EOL
    echo "Created kigit.txt. Please edit this file and re-run the script."
    exit 0
}

fetch_github_token() {
    echo "Fetching GitHub token..."
    if [ -f "$token_file" ]; then
        token=$(cat "$token_file")
        echo "GitHub token fetched."
    else
        echo "GitHub token not found. Please provide your GitHub token."
        read -sp "Enter GitHub token: " token
        echo "$token" > "$token_file"
        chmod 600 "$token_file"
        echo "GitHub token saved."
    fi
}

read_kigit_config() {
    echo "Starting to read kigit configuration..."
    declare -A config
    if [ ! -f "$config_file" ]; then
        initialize_kigit
    fi

    local keys=("set303a" "set303i" "set303b" "set303c" "set303d" "set303e" "set303f" "set303g" "set303h" "set303j" "set303k" "set303l")
    while IFS= read -r line; do
        key=$(echo "$line" | cut -d'=' -f1 | tr -d '[:space:]')
        value=$(echo "$line" | cut -d'=' -f2- | sed 's/^[[:space:]]*//')
        echo "Debug: key=${key}, value=${value}"
        if [[ "$key" =~ ^set303 ]]; then
            config["${key#*set303}"]="$value"
        fi
    done < "$config_file"

    for key in "${keys[@]}"; do
        if [ -z "${config[$key]}" ]; then
            config[$key]="default"
            echo "Appending missing config: $key=default"
            echo "$key=default" >> "$config_file"
        fi
    done
    echo "Configuration read."
}

change_ownership() {
    local user=$(whoami)
    echo "Changing ownership of all files to $user..."
    sudo chown -R "$user":"$user" "$script_dir"
    echo "Ownership changed."
}

setup_git() {
    echo "Setting up Git repository..."
    [ ! -d ".git" ] && git init
    
    [ ! -f ".gitignore" ] && cat > .gitignore <<EOL
# Ignore OS-specific files
.DS_Store
Thumbs.db
# IDE files
.idea/
.vscode/
# Sensitive files
.env
# Build files
build/
dist/
*.o
*.exe
*.dll
*.so
EOL
    git add .gitignore
    git commit -m "Add .gitignore" || true
    echo "Git repository setup complete."
}

create_or_update_repo() {
    local repo_name=${config[b]}
    echo "Checking if repository exists: $repo_name"
    local repo_exists=$(gh repo view "$repo_name" --json name --jq '.name' 2>/dev/null)
    
    if [ -z "$repo_exists" ]; then
        echo "Creating GitHub repository: $repo_name"
        gh repo create "$repo_name" --${config[c]} --enable-issues --enable-wiki || error "Failed to create GitHub repository"
    else
        echo "Repository $repo_name already exists."
    fi
    echo "GitHub repository created or updated."
}

# Main script execution
fetch_github_token
read_kigit_config
change_ownership
setup_git
create_or_update_repo

# Simplified Git commands for testing
git add .
git commit -m "Auto commit"
git push origin master

echo "Script execution completed."
