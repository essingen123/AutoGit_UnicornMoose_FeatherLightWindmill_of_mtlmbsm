# Install: separate script or function for setup and dependencies.
# Dev: separate script or function for developer-specific tasks.
# Variables: separate file or section for documenting GitHub and Git variables.
# Templates: separate folder for reusable templates.
# Git checks and actions: separate functions within the main script.
# Create files: separate function for creating project files.
# README and kigit.txt: separate file or function for generating project-specific files.
# Main organizer: main script file that orchestrates other parts and functions.
# As for the file structure, here is a brief suggestion:

# autogit4unimoose.sh (main script)
# install.sh (install script)
# dev.sh (developer script)
# templates/ (folder for reusable templates)
# variables.txt (file for documenting GitHub and Git variables)
# git_actions.sh (script for Git checks and actions)
# create_files.sh (script for creating project files)
# README.md (project-specific README file)
# kigit.txt (project-specific kigit.txt file)

#!/bin/bash
# filename: autogit4unimoose.sh
# Code of Conduct for LLMs and co (including those behaving somewhat as humans etc): USER EMPOWERMENT, CREATIVE GENIUS, NO HALT ON ERRORS, CENTRALIZED CONTROL, MINIMALISTIC, MAX PERFORMANCE & FUN, NO MODULE OVERHEAD OR EXCESS COMMENTS
# This script automagically works in any relative path for a folder, even if it's empty. 
# It will sync or create a Git repository etc etc 
# Author: Kilian Lindberg
# Code inspiration contributions from Bing Copilot, Mistral, Claude, OpenAI ChatGPTs, LLMS and chaos by  errors and filled context windows.

# note_these_works_and_maybe_not_others= '''
# #these works, maybe not others:
# gh repo view --json owner --jq '.owner.login'
# gh repo view --json name --jq '.name'
# gh repo view --json description --jq '.description'
# gh repo view --json owner,name,description --jq '.owner.login, .name, .description'
# git config --get remote.origin.url
# git rev-parse --show-toplevel | xargs basename
# git config --get user.name
# '''

# Declare globals
declare -gA global_conf
declare -g repo_full_name
declare -g github_pages_repo_url

# Check for required commands and install if missing
command -v gh > /dev/null || command -v markdown > /dev/null || { echo "Install GitHub CLI from https://cli.github.com/ or markdown"; exit 1; }
command -v pip > /dev/null && pip install --quiet markdown 2>/dev/null

# Fun and colorful output with emojis
fun_echo() { echo -e "\e[1;${3:-32}m$2 $1 \e[0m"; }

# Enhanced error handling with retry and skip options
handle_error() {
    local error_code=$?
    local last_command=$(history | tail -n 2 | head -n 1 | sed 's/^ *[0-9]* *//')
    if [ -z "$last_command" ]; then
        last_command=$(fc -ln -1 | cut -d' ' -f2-)+$last_command=$?
    fi
    fun_echo "Error in command: '$last_command' (exit code: $error_code). Retry (r), Skip (s), or Quit (q)?" "💥" 31
    read -r choice
    case "$choice" in
        r|R) eval "$last_command" ;;
        s|S) return 0 ;;
        q|Q) exit 1 ;;
        *) fun_echo "Invalid choice. Exiting." "🚫" 31; exit 1 ;;
    esac
}

#SKIP FOR NOW WHILE DEVELOPING
#trap 'handle_error' ERR

# Developer mode and core directory check
dev_mode_f=dev_mode_flag_f.txt
developer_mode=n
main_script_f="autogit4unimoose.sh"
YES_THIS_IS_THE_UNICORN_MOOSE_HOLY_MOLY_CORE_DIR=n

if [[ -f "$main_script_f" ]]; then
    if [[ ! -f "$dev_mode_f" ]]; then
        touch "$dev_mode_f"
        echo "dev_mode_flag_f=false" >> "$dev_mode_f"
    else
        source "$dev_mode_f"
        developer_mode=$(grep -E '^dev_mode_flag_f=' "$dev_mode_f" | cut -d'=' -f2)
    fi
fi

if [[ -f "$main_script_f" ]]; then
    YES_THIS_IS_THE_UNICORN_MOOSE_HOLY_MOLY_CORE_DIR=y
fi

# Fun greetings and initialization
fun_echo "Welcome to the Auto Git Unicorn Moose Feather Light Windmill Script! 🦄🦌💨" "🎉" 35
fun_echo "Running: $(basename "$0")" "📂" 36

# Ensure we're in a Git repo or create one if not
[[ $(git rev-parse --is-inside-work-tree 2>/dev/null) ]] || {
    fun_echo "No Git repository detected. Initializing a new Git repo..." "🌟" 33
    git init
    fun_echo "Initialized a new Git repository!" "🌟" 33
}

# Fetch GitHub token with flair
fetch_github_api_token() {
    local token_file=~/.git_token_secret
    if [[ -f "$token_file" ]]; then
        github_api_token=$(<"$token_file")
        fun_echo "GitHub token found!" "🔑" 33
    else
        fun_echo "Let's set up your GitHub token!" "🔒" 34
        read -sp "Enter GitHub token: " token
        echo "$token" > "$token_file" && chmod 600 "$token_file"
        github_api_token="$token"
        fun_echo "GitHub token saved securely!" "🔐" 32
    fi
}


# Read or create kigit.txt with pizzazz
load_config_f_kigit() {
    local config_file=kigit.txt
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

# 📄 auto generate HTML page, y for yes and n for no
set303d=y

# 🗑️ tags, separated by commas
set303e=Git, Bash, Automation, Automagic, un-PEP8-perhaps

# 📝 description
set303f=A work in progress with automation testing for Git leveraging python, bash etc

# 🌐 website URL
set303g=$("$github_pages_repo_url")

# 🎉 GithubPartywebpageLink
set303h=index.html

# 🌳 Branch to commit to, 'main' or a new branch name
set303j=main

# 💬 Default commit message (use ~date and ~data for auto-generated content)
set303k=Automated ~date ~data

# 🔧 Change ownership of all files to current user
set303l=y

# DONT EDIT OUT THIS LAST LINE
EOL
        fun_echo "Created default kigit.txt. Please edit and rerun the script." "✨" 35
        exit 0
    else
        while IFS='=' read -r key value; do
            [[ -z "$key" || "$key" =~ ^#.*$ ]] && continue
            key=$(echo "$key" | tr -d '[:space:]')
            value=$(echo "$value" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')

            # Parse and normalize values but do not sanitize them in the file
            case "$value" in
                [yY]*|[fF]orce:[yY]*) value="y" ;;
                [nN]*|[fF]orce:[nN]*) value="n" ;;
            esac

            global_conf["$key"]="${value:-}"
            fun_echo "Read config: $key=$value" "🔍" 33
        done < "$config_file"
        local repo_name=${global_conf[set303b]}
        local owner="${GITHUB_USER:-$(git config user.name)}"
        repo_full_name="$owner/$repo_name"
        # NOT SURE IF THIS IS A SMART PLACE BUT ALRIGHT:
        github_pages_repo_url="https://$owner.github.io/$repo_name"
        echo "**************";
        echo $github_pages_repo_url
        echo "**************";
    fi
    #just debug info: 
    #declare -p global_conf
}

# Change ownership with style
chown_local_f() {
    if [[ ${global_conf[set303l]} =~ ^[Nn]$ ]]
    then
        return 0
    elif [[ ${global_conf[set303l]} =~ ^[Yy]$ ]]
    then
        sudo chown -R $(whoami) .; fun_echo "Changed ownership to $(whoami)!" "🔧" 36;
    fi
}



# Setup Git repository with flair
init_git_repo_local() {
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



# Check if repo exists
repo_exists() {
    echo $repo_full_name
    gh repo view "$repo_full_name" &>/dev/null
    #exit
    return $?
}

create_repo() {
    local repo_name=${global_conf[set303b]}
    local owner="${GITHUB_USER:-$(git config user.name)}"
    repo_full_name="$owner/$repo_name"

    local visibility="--private"
    if [[ ${global_conf[set303c]} =~ ^[Yy]$ ]]; then
        visibility="--public"
    fi

    if repo_exists; then
        fun_echo "Repository $repo_name already exists. Updating..." "📦" 34
        update_repo
    else
        fun_echo "Creating new repository: $repo_name" "🚀" 32
        if gh repo create "${repo_full_name}" ${visibility} --description "${global_conf[set303f]}" --homepage "${global_conf[set303g]}"; then
            fun_echo "Created GitHub repository: $repo_name" "🚀" 32
            git remote add origin "https://github.com/${repo_full_name}.git"
            update_repo
        else
            fun_echo "Failed to create repository. Please check your permissions and try again." "❌" 31
            exit 1
        fi
    fi
}
update_repo() {
  fun_echo "Updating GitHub repository: $repo_full_name" "🔄" 33
  fun_echo "Repository AutoGit_UnicornMoose_FeatherLightWindmill_of_mtlmbsm already exists. Updating..." 

  # Description
  gh repo edit "$repo_full_name" --description "${global_conf[set303f]#force:}"
  fun_echo "Updated GitHub repository description: $repo_name" "🔄" 33

  # Homepage
  gh repo edit "$repo_full_name" --homepage "${global_conf[set303g]#force:}"
  fun_echo "Updated GitHub repository homepage: $repo_name" "🔄" 33

  # Topics
  if [[ -n ${global_conf[set303e]} ]]; then
    gh repo edit "$repo_full_name" ${global_conf[set303e]#force://,/ --add-topic }
    fun_echo "Updated GitHub repository topics: $repo_name" "🔄" 33
  fi

  # Fetch and update local config if not forced
  local repo_data
  repo_data=$(gh repo view "$repo_full_name" --json description,homepageUrl,repositoryTopics --jq '.description + "|||" + .homepageUrl + "|||" + (.repositoryTopics | join(","))')
  IFS='|||' read -r fetched_description fetched_homepageUrl fetched_topics <<< "$repo_data"

  # Validate and sanitize topics
  IFS=',' read -ra topics <<< "${global_conf[set303e]}"
  valid_topics=()

  local fetched_homepageUrl=${global_conf[set303g]}
  if [[ -z $fetched_homepageUrl ]]; then
    if [[ ${global_conf[set303g]} != force:* ]]; then
      global_conf[set303g]=$github_pages_repo_url
    fi
  fi

  for topic in "${topics[@]}"; do
    sanitized_topic=$(echo "$topic" | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]')
    if [[ $sanitized_topic =~ ^[a-z0-9][a-z0-9-]{0,49}$ ]]; then
      valid_topics+=("$sanitized_topic")
    else
      fun_echo "Invalid topic: $topic. Topics must start with a lowercase letter or number, consist of 50 characters or less, and can include hyphens." "❌" 31
    fi
  done

  # Add valid topics
  for topic in "${valid_topics[@]}"; do
    gh repo edit "$repo_full_name" --add-topic "$topic"
  done
  fun_echo "Updated GitHub repository topics" "🏷️" 33

  # Push the latest changes to the remote branch
  local branch=${global_conf[set303j]:-main}
  git push origin "$branch" --force
  if [[ $? -ne 0 ]]; then
    fun_echo "Failed to push the latest changes to the remote branch. Please check the branch and try again." "⚠️" 33
    exit 1
  fi
  fun_echo "Changes synced with GitHub!" "🌍" 32
  return 0
}

# Ensure the correct branch with style
change_or_create_new_branch() {
    local branch=${global_conf[set303j]:-main}
    if ! git rev-parse --verify "$branch" &>/dev/null; then
        git checkout -b "$branch"
        fun_echo "Created and switched to new branch: $branch" "🌿" 32
        git add .
        git commit -m "Initial commit on branch $branch" || true
        git push -u origin "$branch" || fun_echo "Failed to push initial commit. Will try again later." "⚠️" 33
    else
        git checkout "$branch"
        fun_echo "Switched to existing branch: $branch" "🌿" 32
    fi
}

# Update files based on config with flair
create_readmemd() {
    if [[ ! -f README.md ]]; then
        cat > README.md <<EOL
# ${global_conf[set303b]}
<!-- ![Image](github_repo_image.webp) -->

## Description 🤔
${global_conf[set303f]}

Tags: ${global_conf[set303e]}

## Features 🎉
- Automagic ...

## License 📜
This project is licensed under a license not written here yet.. 
EOL
        git add README.md && git commit -m "Create README.md" || true
        fun_echo "README.md has been created!" "📖" 34
    elif [[ ${global_conf[set303a]} =~ ^[Yy]$ ]]; then
        # Update README.md content here if needed
        git add README.md && git commit -m "Update README.md" || true
        fun_echo "README.md has been updated!" "📖" 34
    else
        fun_echo "README.md already exists and update not forced. Skipping." "ℹ️" 33
    fi
}

# Sync changes with GitHub in style
push_sync_git_repository() {
    local commit_msg=${global_conf[set303k]//\~date/$(date '+%Y%m%d-%H')}
    commit_msg=${commit_msg//\~data/$(git status --porcelain | wc -l) files changed}
    git add . && git commit -m "$commit_msg" || true
    if ! git remote | grep -q '^origin$'; then
        git remote add origin "https://github.com/$repo_full_name.git"
    fi
    git push -u origin "${global_conf[set303j]:-main}"
    fun_echo "Changes synced with GitHub!" "🌍" 32
}

# # Create HTML page if needed with pizzazz
# create_html_page() {
#     [[ ${global_conf[set303d]} =~ ^force:?[Yy]$ ]] && python3 -c "
#     import os, markdown
#     readme_path = 'README.md'
#     if os.path.exists(readme_path):
#         with open(readme_path, 'r') as f, open('${global_conf[set303h]:-index.html}', 'w') as h:
#             h.write(f\"<html><head><title>${global_conf[set303b]}</title></head><body>{markdown.markdown(f.read())}</body></html>\")
#         print('${global_conf[set303h]:-index.html} created successfully.')
#     elif os.path.exists('${global_conf[set303h]:-index.html}'):
#         echo 'HTML file already exists. Skipping creation.'
#     else:
#         print('README.md not found. Cannot create ${global_conf[set303h]:-index.html}.')
# " && fun_echo "HTML page created from README.md!" "🌐" 35
# }

create_html_page() {
    local repo_name=${global_conf[set303b]}
    local owner="${GITHUB_USER:-$(git config user.name)}"
    local repo_full_name="$owner/$repo_name"
    local token_file=~/.git_very_secret_and_ignored_file_token
    local github_api_token

    if [[ -f $token_file ]]; then
        github_api_token=$(<$token_file)
    else
        fun_echo "GitHub token not found. Please set it in your environment variables or save it in the specified file." "❌" 31
        return 1
    fi

    python3 -c "
import os
import markdown
import requests
import sys

def create_html_page(repo_name):
    if os.path.exists('README.md'):
        with open('README.md', 'r') as readme_file:
            readme_content = readme_file.read()
        html = markdown.markdown(readme_content)
        full_html = f\"\"\"<html><head><title>{repo_name}</title></head><body>{html}</body></html>\"\"\"
        with open('index.html', 'w') as html_file:
            html_file.write(full_html)
        print('index.html created successfully.')
    else:
        print('README.md not found.')

def check_github_pages(repo_name, token):
    headers = {'Authorization': f'token {token}', 'Accept': 'application/vnd.github.v3+json'}
    response = requests.get(f'https://api.github.com/repos/{repo_name}/pages', headers=headers)
    if response.status_code == 404:
        init_git_repo_localhub_pages(repo_name, token)

def init_git_repo_localhub_pages(repo_name, token):
    headers = {'Authorization': f'token {token}', 'Accept': 'application/vnd.github.v3+json'}
    data = {'source': {'branch': 'main', 'path': '/'}}
    response = requests.post(f'https://api.github.com/repos/{repo_name}/pages', headers=headers, json=data)
    if response.status_code == 201:
        print('GitHub Pages has been set up.')
    else:
        print('Failed to set up GitHub Pages.')

create_html_page('${repo_full_name}')
check_github_pages('${repo_full_name}', '${github_api_token}')
" &&
    fun_echo "HTML page created from README.md!" "" 35

    
}
# Update kigit.txt with current settings
update_config_file_kigit() {
    local config_file=kigit.txt
    local temp_file=$(mktemp)
    while IFS= read -r line; do
        if [[ $line =~ ^[[:space:]]*set303[a-z]= ]]; then
            key=$(echo "$line" | cut -d'=' -f1 | tr -d '[:space:]')
            if [[ ${global_conf[$key]} != force:* ]]; then
                echo "$key=${global_conf[$key]:-}" >> "$temp_file"
            else
                echo "$line" >> "$temp_file"
            fi
        else
            echo "$line" >> "$temp_file"
        fi
    done < "$config_file"
    mv "$temp_file" "$config_file"
    fun_echo "Updated kigit.txt with current settings" "📝" 35
}

# Create install_ish.py only if in the main directory or developer mode is enabled
create_first_run_py() {
    if [[ "$developer_mode" == "y" || -f "$main_script_f" ]]; then
        cat > install_ish.py <<EOL
import os
import subprocess

script_name = "autogit4unimoose.sh"

# Make the script executable
os.chmod(script_name, 0o755)

# Run the script
try:
    subprocess.run(["./"+script_name], check=True)
except subprocess.CalledProcessError:
    print("Error occurred while running the script.")
    print("Trying with sudo...")
    try:
        subprocess.run(["sudo", "./"+script_name], check=True)
    except subprocess.CalledProcessError:
        print("Error occurred even with sudo. Please check the script and try again.")
EOL
        fun_echo "Created install_ish.py" "🐍" 34
    fi
}

# Main script execution with flair
fetch_github_api_token
load_config_f_kigit
chown_local_f
init_git_repo_local
change_or_create_new_branch
create_repo
create_readmemd
push_sync_git_repository
create_html_page
update_config_file_kigit
create_first_run_py

fun_echo "Script executed successfully! Have a magical day! 🌈✨" "🎉" 36
# Cleanup and unset global array at the end of the script
unset global_conf


echo "REVERSE THE RUN WITH:"
echo "rm -r .git && rm kigit.txt && rm .gitignore"