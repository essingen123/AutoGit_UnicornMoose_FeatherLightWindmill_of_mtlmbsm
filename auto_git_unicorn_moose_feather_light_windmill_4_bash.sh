#!/bin/bash
# filename: auto_git_unicorn_moose_feather_light_windmill_4_bash.sh
# Code of Conduct for LLMs and co (including those behaving somewhat as humans etc): USER EMPOWERMENT, CREATIVE GENIUS, NO HALT ON ERRORS, CENTRALIZED CONTROL, MINIMALISTIC, MAX PERFORMANCE & FUN, NO MODULE OVERHEAD OR EXCESS COMMENTS
# This script automagically works in any relative path for a folder, even if it's empty. It will initialize a Git repository and create a GitHub repo if needed.
# Author: Kilian Lindberg
# Inspirational code inspiration contributions: Bing Copilot, Mistral, Claude, OpenAI ChatGPTs, and other LLMs.
# Avoid chaos by minimizing errors and filled context windows.
# NOTE: The script sanitizes input values for internal processing (e.g., trimming spaces) but does not modify or sanitize the 'kigit.txt' file itself. This ensures user inputs are preserved as originally written.


# Declare globals
declare -gA kilian_air_autogit_unicornmoose_303_temp_global
declare -g repo_full_name

# Check for required commands and install if missing
command -v gh > /dev/null || { echo "Install GitHub CLI from https://cli.github.com/"; exit 1; }
command -v pip > /dev/null && pip install markdown 2>/dev/null

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
developer_mode_file=kigit_UNICORN_MOOSE_DEVELOPER_MODE_CONFIG.txt
developer_mode=n
main_script_file="auto_git_unicorn_moose_feather_light_windmill_4_bash.sh"
YES_THIS_IS_THE_UNICORN_MOOSE_HOLY_MOLY_CORE_DIR=n

if [[ -f "$main_script_file" ]]; then
    source "$developer_mode_file"
    developer_mode=$(grep -E '^kigit_UNICORN_MOOSE_DEVELOPER_MODE_CONFIG=' "$developer_mode_file" | cut -d'=' -f2)
fi

if [[ -f "$main_script_file" ]]; then
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
        while IFS='=' read -r key value; do
            [[ -z "$key" || "$key" =~ ^#.*$ ]] && continue
            key=$(echo "$key" | tr -d '[:space:]')
            value=$(echo "$value" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')

            # Parse and normalize values but do not sanitize them in the file
            case "$value" in
                [yY]*|[fF]orce:[yY]*) value="y" ;;
                [nN]*|[fF]orce:[nN]*) value="n" ;;
            esac

            kilian_air_autogit_unicornmoose_303_temp_global["$key"]="${value:-}"
        done < "$config_file"
        local repo_name=${kilian_air_autogit_unicornmoose_303_temp_global[set303b]}
        local owner="${GITHUB_USER:-$(git config user.name)}"
        repo_full_name="$owner/$repo_name"
    fi
    declare -p kilian_air_autogit_unicornmoose_303_temp_global
}

# Change ownership with style
change_ownership() {
    if [[ ${kilian_air_autogit_unicornmoose_303_temp_global[set303l]} =~ ^[Nn]$ ]]
    then
        return 0
    elif [[ ${kilian_air_autogit_unicornmoose_303_temp_global[set303l]} =~ ^[Yy]$ ]]
    then
        sudo chown -R $(whoami) .; fun_echo "Changed ownership to $(whoami)!" "🔧" 36;
    fi
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



# Check if repo exists
repo_exists() {
    local repo_name=$1
    local owner="${GITHUB_USER:-$(git config user.name)}"
    echo "Checking if repo exists: $repo_full_name"
    gh repo view "$repo_full_name" &>/dev/null
    echo "Repo check result: $?"
}

handle_repository() {
    local repo_name=${kilian_air_autogit_unicornmoose_303_temp_global[set303b]}
    local owner="${GITHUB_USER:-$(git config user.name)}"
    repo_full_name="$owner/$repo_name"

    local visibility="--private"
    [[ ${kilian_air_autogit_unicornmoose_303_temp_global[set303c]} =~ ^[Yy]$ ]] && visibility="--public"

    if repo_exists "$repo_name"; then
        fun_echo "Repository $repo_name already exists. Updating..." "📦" 34
        update_repo
    else
        fun_echo "Creating new repository: $repo_name" "🚀" 32
        if gh repo create "$repo_name" $visibility --description "${kilian_air_autogit_unicornmoose_303_temp_global[set303f]}" --homepage "${kilian_air_autogit_unicornmoose_303_temp_global[set303g]}"; then
            fun_echo "Created GitHub repository: $repo_name" "🚀" 32
            update_repo
        else
            fun_echo "Failed to create repository. Please check your permissions and try again." "❌" 31
            exit 1
        fi
    fi
}

update_repo() {
    
    echo "Updating GitHub repo: $repo_full_name"

    if gh repo edit "$repo_full_name" --description "${kilian_air_autogit_unicornmoose_303_temp_global[set303f]}" --homepage "${kilian_air_autogit_unicornmoose_303_temp_global[set303g]}" --add-topic "${kilian_air_autogit_unicornmoose_303_temp_global[set303e]//,/ --add-topic }"; then
        fun_echo "Updated GitHub repository: $repo_name" "🔄" 33

        # Fetch and update local config if not forced
        local repo_data
        repo_data=$(gh repo view "$repo_full_name" --json description,homepageUrl,repositoryTopics --jq '.description + "|||" + .homepageUrl + "|||" + (.repositoryTopics | join(","))')
        IFS='|||' read -r fetched_description fetched_homepage fetched_topics <<< "$repo_data"

        [[ ${kilian_air_autogit_unicornmoose_303_temp_global[set303f]} != force:* ]] && kilian_air_autogit_unicornmoose_303_temp_global[set303f]=$fetched_description
        [[ ${kilian_air_autogit_unicornmoose_303_temp_global[set303g]} != force:* ]] && kilian_air_autogit_unicornmoose_303_temp_global[set303g]=$fetched_homepage
        [[ ${kilian_air_autogit_unicornmoose_303_temp_global[set303e]} != force:* ]] && kilian_air_autogit_unicornmoose_303_temp_global[set303e]=$fetched_topics
    else
        fun_echo "Failed to update GitHub repository" "❌" 31
    fi
}

# Ensure the correct branch with style
ensure_branch() {
    local branch=${kilian_air_autogit_unicornmoose_303_temp_global[set303j]:-master}
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
    if [[ ! -f README.md ]]; then
        cat > README.md <<EOL
# ${kilian_air_autogit_unicornmoose_303_temp_global[set303b]}

${kilian_air_autogit_unicornmoose_303_temp_global[set303f]}

Tags: ${kilian_air_autogit_unicornmoose_303_temp_global[set303e]}

![Auto Git Unicorn Moose Feather Light Windmill](auto_git_unicorn_moose_feather_light_windmill_of_mtlmbsm.webp)

## What is MTLMBSM? 🤔
MTLMBSM stands for "Meh To Less Meh But Still Meh," a humorous way to describe how 
this script simplifies and automates aspects of version control and GitHub interactions; which also serves as a filter; since if this is yet not automagically enforcing a smile near the observer, this script may not be suitable at all; almost like an admin requirement certification wise thing. 

## Features 🎉
- Automagic operation (YES, PREFERABLY even if there's an error or missing configuration, in authentic unicorn moose manners! )
- Flexible configuration through kigit.txt
- Repository creation & management
- Automatic README.md & .gitignore generation etc intended
- (Yet to be more arty) web page generative actions from README.md etc
- Customizable commit messages (-ish)
- And much more, and perhaps even quite differently so (not so awesome) when LLMs misinterpret the "enhance" statement!

## License 📜
This project is licensed under a license not written here yet.. but sure, this has probably taken out a 100 hours of LLM discoteque ettiqeuette etc.
EOL
        git add README.md && git commit -m "Create README.md" || true
        fun_echo "README.md has been created!" "📖" 34
    elif [[ ${kilian_air_autogit_unicornmoose_303_temp_global[set303a]} =~ ^[Yy]$ ]]; then
        # Update README.md content here if needed
        git add README.md && git commit -m "Update README.md" || true
        fun_echo "README.md has been updated!" "📖" 34
    else
        fun_echo "README.md already exists and update not forced. Skipping." "ℹ️" 33
    fi
}

# Sync changes with GitHub in style
sync_repo() {
    local commit_msg=${kilian_air_autogit_unicornmoose_303_temp_global[set303k]//\~date/$(date '+%Y-%m-%d')}
    commit_msg=${commit_msg//\~data/$(git status --porcelain | wc -l) files changed}
    git add . && git commit -m "$commit_msg" || true
    git push -u origin "${kilian_air_autogit_unicornmoose_303_temp_global[set303j]:-master}"
    fun_echo "Changes synced with GitHub!" "🌍" 32
}

# Create HTML page if needed with pizzazz
create_html_page() {
    [[ ${kilian_air_autogit_unicornmoose_303_temp_global[set303d]} =~ ^force:?[Yy]$ ]] && python3 -c "
    import os, markdown
    readme_path = 'README.md'
    if os.path.exists(readme_path):
        with open(readme_path, 'r') as f, open('${kilian_air_autogit_unicornmoose_303_temp_global[set303h]:-index.html}', 'w') as h:
            h.write(f\"<html><head><title>${kilian_air_autogit_unicornmoose_303_temp_global[set303b]}</title></head><body>{markdown.markdown(f.read())}</body></html>\")
        print('${kilian_air_autogit_unicornmoose_303_temp_global[set303h]:-index.html} created successfully.')
    elif os.path.exists('${kilian_air_autogit_unicornmoose_303_temp_global[set303h]:-index.html}'):
        echo 'HTML file already exists. Skipping creation.'
    else:
        print('README.md not found. Cannot create ${kilian_air_autogit_unicornmoose_303_temp_global[set303h]:-index.html}.')
" && fun_echo "HTML page created from README.md!" "🌐" 35
}


# Update kigit.txt with current settings
update_kigit_txt() {
    local config_file=kigit.txt
    local temp_file=$(mktemp)
    while IFS= read -r line; do
        if [[ $line =~ ^[[:space:]]*set303[a-z]= ]]; then
            key=$(echo "$line" | cut -d'=' -f1 | tr -d '[:space:]')
            if [[ ${kilian_air_autogit_unicornmoose_303_temp_global[$key]} != force:* ]]; then
                echo "$key=${kilian_air_autogit_unicornmoose_303_temp_global[$key]:-}" >> "$temp_file"
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

# Create g_first_run.py only if in the main directory or developer mode is enabled
create_g_first_run() {
    if [[ "$developer_mode" == "y" || -f "$main_script_file" ]]; then
        cat > g_first_run.py <<EOL
import os
import subprocess

script_name = "auto_git_unicorn_moose_feather_light_windmill_4_bash.sh"

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
        fun_echo "Created g_first_run.py" "🐍" 34
    fi
}

# Main script execution with flair
fetch_github_token
read_kigit_config
change_ownership
handle_repository
setup_git
ensure_branch
update_files
sync_repo
create_html_page
update_kigit_txt
create_g_first_run

fun_echo "Script executed successfully! Have a magical day! 🌈✨" "🎉" 36
# Cleanup and unset global array at the end of the script
unset kilian_air_autogit_unicornmoose_303_temp_global
