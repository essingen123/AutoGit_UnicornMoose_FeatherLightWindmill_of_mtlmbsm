#!/bin/bash
#filename:auto_git_unicorn_moose_feather_light_windmill_4_bash.sh
# Code of Conduct: USER EMPOWERMENT, CREATIVE GENIUS, NO HALT ON ERRORS, CENTRALIZED CONTROL, MINIMALISTIC, MAX PERFORMANCE & FUN, NO MODULE OVERHEAD OR EXCESS COMMENTS

command -v gh > /dev/null || { echo "Install GitHub CLI from https://cli.github.com/"; exit 1; }
command -v pip > /dev/null && pip install markdown 2>/dev/null

# Fun and colorful output with emojis
fun_echo() { echo -e "\e[1;${3:-32}m$2 $1 \e[0m"; }

# Error handling with style
handle_error() {
    local error_code=$? last_command=$(history 1 | sed 's/^ *[0-9]* *//')
    fun_echo "Oops! Error in: '$last_command' (code: $error_code). Continue? (y/n)" "💥" 31
    read -r choice
    [[ $choice =~ ^[Yy]$ ]] || exit 1
}
trap 'handle_error' ERR

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

# Read or create kigit.txt with pizzazz
read_kigit_config() {
    local config_file=kigit.txt
    declare -A config
    if [[ ! -f "$config_file" ]]; then
        cat > "$config_file" <<EOL
# This is a config file for the auto_git_unicorn_moose_feather .. 🦄
# File: kigit.txt

# 💻 Update(💡)
set303a=y

# 💬 Verbose, output for each terminal run, y for yes and n for no
set303i=y

# 📝 git-reponame (empty for current folder name, 'random' for a random name)
set303b=$(basename "$PWD")

# 🔒 public git, y for yes n for no, standard no
set303c=n

# 📄 auto generate HTML page, y for yes n for no
set303d=y

# 🗑️ tags, separated by commas
set303e=Git, Bash, Automation, Automagic, un-PEP8-perhaps

# 📝 description
set303f=A work in progress with automation testing for Git leveraging python, bash etc

# 🌐 website URL
set303g=

# 🎉 GithubPartywebpageLink
set303h=index.html

# 🌳 Branch to commit to, 'main' or a new branch name
set303j=master

# 💬 Default commit message (use ~date and ~data for auto-generated content)
set303k=Automated ~date ~data

# 🔧 Change ownership of all files to current user
set303l=y

# DONT EDIT OUT THIS LAST LINE
EOL
        fun_echo "Created default kigit.txt. Please edit and rerun the script." "✨" 35
        exit 0
    else
        while IFS= read -r line; do
            [[ "$line" =~ ^#.*$ ]] && continue
            key=$(echo "$line" | cut -d'=' -f1 | tr -d '[:space:]')
            value=$(echo "$line" | cut -d'=' -f2- | sed 's/^[[:space:]]*//')
            config["$key"]="${value:-default_value}"
        done < "$config_file"
    fi
}

# Change ownership with style
change_ownership() {
    [[ ${config[set303l]} =~ ^[Yy]$ ]] && { sudo chown -R $(whoami) .; fun_echo "Changed ownership to $(whoami)!" "🔧" 36; }
}

# Setup Git repository with flair
setup_git() {
    [[ -d .git ]] || { git init; fun_echo "Initialized a new Git repository!" "🌟" 33; }
    if [[ ! -f .gitignore ]]; then
        cat > .gitignore <<EOL
.DS_Store
Thumbs.db
.idea/
.vscode/
.env
build/
dist/
*.o
*.exe
*.dll
*.so
EOL
        git add .gitignore && git commit -m "Add .gitignore" || true
        fun_echo "Created and added .gitignore!" "📄" 32
    fi
}

# Fetch data from GitHub repo to kigit.txt with style
fetch_github_data() {
    local repo_name=${config[set303b]} repo_exists
    repo_exists=$(gh repo view "$repo_name" --json name --jq '.name' 2>/dev/null)
    if [[ -n "$repo_exists" ]]; then
        local repo_data=$(gh repo view "$repo_name" --json description,homepage,topics --jq '.description + "|||" + .homepage + "|||" + (.topics | join(","))')
        IFS='|||' read -r fetched_description fetched_homepage fetched_topics <<< "$repo_data"
        [[ -z ${config[set303f]} ]] && config[set303f]=$fetched_description
        [[ -z ${config[set303g]} ]] && config[set303g]=$fetched_homepage
        [[ -z ${config[set303e]} ]] && config[set303e]=$fetched_topics
        fun_echo "Fetched data from GitHub repo: $repo_name" "📦" 34
    else
        fun_echo "Creating new GitHub repo: $repo_name" "✨" 35
        create_or_update_repo
    fi
}

# Create or update GitHub repository with pizzazz
create_or_update_repo() {
    local repo_name=${config[set303b]} repo_exists
    repo_exists=$(gh repo view "$repo_name" --json name --jq '.name' 2>/dev/null)
    if [[ -z "$repo_exists" ]]; then
        gh repo create "$repo_name" --${config[set303c]:-private} --description "${config[set303f]}" --homepage "${config[set303g]}" || { fun_echo "Failed to create GitHub repository" "❌" 31; exit 1; }
        fun_echo "Created GitHub repository: $repo_name" "🚀" 32
    else
        gh repo edit "$repo_name" --description "${config[set303f]}" --homepage "${config[set303g]}" --add-topic "${config[set303e]//,/ --add-topic }" || { fun_echo "Failed to update GitHub repository" "❌" 31; exit 1; }
        fun_echo "Updated GitHub repository: $repo_name" "🔄" 33
    fi
}

# Ensure the correct branch with style
ensure_branch() {
    local branch=${config[set303j]:-master}
    git checkout -b "$branch" 2>/dev/null || git checkout "$branch"
    fun_echo "Switched to branch: $branch!" "🌿" 32
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
    fi
}

# Sync changes with GitHub in style
sync_repo() {
    local commit_msg=${config[set303k]//\~date/$(date +%Y%m%d%H%M%S)}
    commit_msg=${commit_msg//\~data/$(git status --porcelain | wc -l) files changed}
    git add . && git commit -m "$commit_msg" || true
    git push -u origin "${config[set303j]:-master}"
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

# Main script execution with flair
fetch_github_token
read_kigit_config
change_ownership
setup_git
fetch_github_data
create_or_update_repo
ensure_branch
update_files
sync_repo
create_html_page

fun_echo "Script executed successfully! Have a magical day! 🌈✨" "🎉" 36