#!/bin/bash
#filename:auto_git_unicorn_moose_feather_light_windmill_4_bash.sh
# Code of Conduct: USER EMPOWERMENT, CREATIVE GENIUS, NO HALT ON ERRORS, CENTRALIZED CONTROL, MINIMALISTIC, MAX PERFORMANCE & FUN, NO MODULE OVERHEAD OR EXCESS COMMENTS
# Update if exists.. and create if a new name is given etc; the logic is quite evident here :)

command -v gh > /dev/null || { echo "Install GitHub CLI from https://cli.github.com/"; exit 1; }
command -v pip > /dev/null && pip install markdown 2>/dev/null

# Fun and colorful output with emojis
fun_echo() { echo -e "\e[1;${3:-32}m$2 $1 \e[0m"; }

# Fun greetings and initialization
fun_echo "Welcome to the Auto Git Unicorn Moose Feather Light Windmill Script! 🦄🦌💨" "🎉" 35
fun_echo "Running: $(basename "$0")" "📂" 36

# Ensure we're in a Git repo
[[ $(git rev-parse --is-inside-work-tree 2>/dev/null) ]] || { fun_echo "Run this in a Git repo!" "❗" 31; exit 1; }

# Fetch GitHub token with flair
fetch_github_token() {
    local token_file=~/.git_token_secret
    if [[ -f "$token_file" ]]; then
        github_token=$(<"$token_file")
        fun_echo "GitHub token found!" "🔑" 33
    else
        fun_echo "Let's set up your GitHub token!" "🔒" 34
        read -sp "Enter GitHub token: " token
        echo "$token" > "$token_file" && chmod 600 "$token_file"
        github_token="$token"
        fun_echo "GitHub token saved securely!" "🔐" 32
    fi
}

# Setup alias
setup_alias() {
    local alias_name="g"
    local script_path=$(realpath "$0")
    local bashrc_path="$HOME/.bashrc"
    
    if ! grep -q "alias $alias_name=" "$bashrc_path"; then
        echo "alias $alias_name='$script_path'" >> "$bashrc_path"
        fun_echo "Alias '$alias_name' added to .bashrc" "🔧" 36
        fun_echo "Please run 'source ~/.bashrc' or restart your terminal to use the alias." "📢" 33
    else
        fun_echo "Alias '$alias_name' already exists in .bashrc" "ℹ️" 34
    fi
}

# Declare the config array as global
declare -gA config

# Read or create kigit.txt with pizzazz
read_kigit_config() {
    local config_file=kigit.txt
    if [[ ! -f "$config_file" ]]; then
        cat > "$config_file" <<EOL
# config file (kigit.txt)
#Update(💡)
set303a=n
#Verbose
set303i=y
#reponame(a new name makes a new repo, empty for this folders paths name)
set303b=$(basename "$PWD")
#public
set303c=n
#gen html page
set303d=y
#tags
set303e=Git, Bash, Automation
#desc
set303f=A GitHub repository created and managed by the Auto Git Unicorn Moose Feather Light Windmill Script
#website
set303g=
#GithubPartywebpageLink
set303h=index.html
#Branch (a new name makes a new branch)
set303j=main
#autocommit message ~date ~data is auto generating relevant things
set303k=Automated update ~date - ~data
# Change ownership of all files to current user
set303l=n

# DONT EDIT OUT THIS LAST LINE
EOL
        fun_echo "Created default kigit.txt. Please edit and rerun the script." "✨" 35
        fetch_github_token
        setup_alias
        exit 0
    else
        while IFS='=' read -r key value; do
            [[ -z "$key" || "$key" =~ ^#.*$ ]] && continue
            key=$(echo "$key" | tr -d '[:space:]')
            value=$(echo "$value" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')
            config["$key"]="${value:-}"
        done < "$config_file"
    fi
    declare -p config
}

# Change ownership with style
change_ownership() {
    [[ ${config[set303l]} =~ ^[Yy]$ ]] && { sudo chown -R $(whoami) .; fun_echo "Changed ownership to $(whoami)!" "🔧" 36; }
}

# Setup Git repository with flair
setup_git() {
    [[ -d .git ]] || { git init; fun_echo "Initialized a new Git repository!" "🌟" 33; }
    if [[ ! -f .gitignore ]]; then
        echo -e ".DS_Store\nThumbs.db\n.idea/\n.vscode/\n.env\nbuild/\ndist/\n*.o\n*.exe\n*.dll\n*.so" > .gitignore
        git add .gitignore && git commit -m "Add .gitignore" || true
        fun_echo "Created and added .gitignore!" "📄" 32
    fi
}

# Check if repo exists
repo_exists() {
    local repo_name=$1
    local owner="${GITHUB_USER:-$(git config user.name)}"
    echo "Checking if repo exists: $owner/$repo_name"
    gh repo view "$owner/$repo_name" &>/dev/null
    return $?
}

handle_repository() {
    local repo_name=${config[set303b]}
    local owner="${GITHUB_USER:-$(git config user.name)}"
    local visibility="--private"
    [[ ${config[set303c]} =~ ^[Yy]$ ]] && visibility="--public"

    if repo_exists "$repo_name"; then
        fun_echo "Repository $repo_name already exists. Updating..." "📦" 34
        update_repo
    else
        fun_echo "Creating new repository: $repo_name" "🚀" 32
        if gh repo create "$repo_name" $visibility --description "${config[set303f]}" --homepage "${config[set303g]}"; then
            fun_echo "Created GitHub repository: $repo_name" "🚀" 32
            update_repo
        else
            fun_echo "Failed to create repository. Please check your permissions and try again." "❌" 31
            exit 1
        fi
    fi
}

update_repo() {
    local repo_name=${config[set303b]}
    local owner="${GITHUB_USER:-$(git config user.name)}"
    echo "Updating GitHub repo: $owner/$repo_name"
    
    if gh repo edit "$owner/$repo_name" --description "${config[set303f]}" --homepage "${config[set303g]}" --add-topic "${config[set303e]//,/ --add-topic }"; then
        fun_echo "Updated GitHub repository: $repo_name" "🔄" 33
        
        local repo_data
        repo_data=$(gh repo view "$owner/$repo_name" --json description,homepageUrl,repositoryTopics --jq '.description + "|||" + .homepageUrl + "|||" + (.repositoryTopics | join(","))')
        IFS='|||' read -r fetched_description fetched_homepage fetched_topics <<< "$repo_data"
        
        [[ ${config[set303f]} != force:* ]] && config[set303f]=$fetched_description
        [[ ${config[set303g]} != force:* ]] && config[set303g]=$fetched_homepage
        [[ ${config[set303e]} != force:* ]] && config[set303e]=$fetched_topics
    else
        fun_echo "Failed to update GitHub repository" "❌" 31
    fi
}

# Ensure the correct branch with style
ensure_branch() {
    local branch=${config[set303j]:-main}
    if ! git rev-parse --verify "$branch" &>/dev/null; then
        git checkout -b "$branch"
        fun_echo "Created and switched to new branch: $branch" "🌿" 32
    else
        git checkout "$branch"
        fun_echo "Switched to existing branch: $branch" "🌿" 32
    fi
}

# Update files based on config with flair
update_files() {
    if [[ ! -f README.md ]] || [[ ${config[set303a]} =~ ^[Yy]$ ]]; then
        cat > README.md <<EOL
# ${config[set303b]}

${config[set303f]}

Tags: ${config[set303e]}

![Auto Git Unicorn Moose Feather Light Windmill](auto_git_unicorn_moose_feather_light_windmill_of_mtlmbsm.webp)

## What is MTLMBSM? 🤔
MTLMBSM stands for "Meh To Less Meh But Still Meh," a humorous way to describe how this script simplifies and automates aspects of version control and GitHub interactions.

## Features 🎉
- Automagic operation (unless there's an error or missing configuration)
- Flexible configuration through kigit.txt
- Repository creation and management
- Automatic README.md and .gitignore generation
- HTML page generation from README.md
- Customizable commit messages
- And much more!

## License 📜
This project is licensed under the MIT License.
EOL
        git add README.md && git commit -m "Update README.md" || true
        fun_echo "README.md has been updated!" "📖" 34
    else
        fun_echo "README.md already exists and update not forced. Skipping." "ℹ️" 33
    fi
}

# Sync changes with GitHub in style
sync_repo() {
    local commit_msg=${config[set303k]//\~date/$(date +%Y%m%d%H%M%S)}
    commit_msg=${commit_msg//\~data/$(git status --porcelain | wc -l) files changed}
    git add . && git commit -m "$commit_msg" || true
    git push -u origin "${config[set303j]:-main}"
    fun_echo "Changes synced with GitHub!" "🌍" 32
}

# Create HTML page if needed with pizzazz
create_html_page() {
    [[ ${config[set303d]} =~ ^[Yy]$ ]] && python3 -c "
import os, markdown
readme_path = 'README.md'
if os.path.exists(readme_path):
    with open(readme_path, 'r') as f, open('${config[set303h]:-index.html}', 'w') as h:
        h.write(f\"<html><head><title>${config[set303b]}</title></head><body>{markdown.markdown(f.read())}</body></html>\")
    print('${config[set303h]:-index.html} created successfully.')
else:
    print('README.md not found. Cannot create ${config[set303h]:-index.html}.')
" && fun_echo "HTML page created from README.md!" "🌐" 35
}

# Update kigit.txt with current settings
update_kigit_txt() {
    local config_file=kigit.txt
    local temp_file=$(mktemp)
    while IFS= read -r line; do
        if [[ $line =~ ^[[:space:]]*set303[a-z]= ]]; then
            key=$(echo "$line" | cut -d'=' -f1)
            echo "$key=${config[$key]:-}"
        else
            echo "$line"
        fi
    done < "$config_file" > "$temp_file"
    mv "$temp_file" "$config_file"
    fun_echo "Updated kigit.txt with current settings" "📝" 35
}

# Main script execution with flair
fetch_github_token
read_kigit_config
change_ownership
setup_git
handle_repository
ensure_branch
update_files
sync_repo
create_html_page
update_kigit_txt
 
fun_echo "Script executed successfully! Have a magical day! 🌈✨" "🎉" 36