#!/bin/bash

#!/bin/bash

# Colorful output functions
fun_echo() {
    local color_code=$3
    echo -e "\e[${color_code:-32}m$2 $1 \e[0m"
}

fun_error() {
    fun_echo "$1" "Error: " 31
}

# Error handling function
handle_error() {
    local error_code=$?
    local last_command=$(history | tail -n 2 | head -n 1 | sed 's/^ *[0-9]* *//')
    if [ -z "$last_command" ]; then
        last_command=$(fc -ln -1 | cut -d' ' -f2-)
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

            autogit_global_a["$key"]="${value:-}"
        done < "$config_file"
        local repo_name=${autogit_global_a[set303b]}
        local owner="${GITHUB_USER:-$(git config user.name)}"
        repo_full_name="$owner/$repo_name"
    fi
    declare -p autogit_global_a
}

# Change ownership with style
change_ownership() {
    if [[ ${autogit_global_a[set303l]} =~ ^[Nn]$ ]]; then
        return 0
    elif [[ ${autogit_global_a[set303l]} =~ ^[Yy]$ ]]; then
        sudo chown -R $(whoami) . && fun_echo "Changed ownership to $(whoami)!" "🔧" 36
    fi
}

# Setup Git repository with flair
setup_git() {
    [[ -d .git ]] || { git init && fun_echo "Initialized a new Git repository!" "🌟" 33; }
    if [[ ! -f .gitignore ]]; then
        cat > .gitignore <<EOL
.DS_Storestyle
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

# Ensure the correct branch with style
ensure_branch() {
    local branch=${autogit_global_a[set303j]:-master}
    if ! git rev-parse --verify "$branch" &>/dev/null; then
        git checkout -b "$branch" && fun_echo "Created and switched to new branch: $branch" "🌿" 32
        git add . && git commit -m "Initial commit on branch $branch" || true
        git push -u origin "$branch" || fun_echo "Failed to push initial commit. Will try again later." "⚠️" 33
    else
        git checkout "$branch" && fun_echo "Switched to existing branch: $branch" "🌿" 32
    fi
}

# Update files based on config with flair
update_files() {
    if [[ ! -f README.md ]]; then
        cat > README.md <<EOL
# ${autogit_global_a[set303b]}

${autogit_global_a[set303f]}

Tags: ${autogit_global_a[set303e]}

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
    elif [[ ${autogit_global_a[set303a]} =~ ^[Yy]$ ]]; then
        # Update README.md content here if needed
        git add README.md && git commit -m "Update README.md" || true
        fun_echo "README.md has been updated!" "📖" 34
    else
        fun_echo "README.md already exists and update not forced. Skipping." "ℹ️" 33
    fi
}

# Sync changes with GitHub in style
sync_repo() {
    local commit_msg=${autogit_global_a[set303k]//\~date/$(date '+%Y-%m-%d')}
    commit_msg=${commit_msg//\~data/$(git status --porcelain | wc -l) files changed}
    if [ -z "$commit_msg" ]; then
        commit_msg="Auto commit on $(date '+%Y-%m-%d') with $(git status --porcelain | wc -l) files changed"
    fi
    git add . && git commit -m "$commit_msg" || true
    if ! git remote | grep -q '^origin$'; then
        git remote add origin "https://github.com/$repo_full_name.git"
    fi
    git push -u origin "${autogit_global_a[set303j]:-master}"
    fun_echo "Changes synced with GitHub!" "🌍" 32
}

# Create HTML page if needed with pizzazz
create_html_page() {
    [[ ${autogit_global_a[set303d]} =~ ^force:?[Yy]$ ]] && python3 -c "
    import os, markdown
    readme_path = 'README.md'
    if os.path.exists(readme_path):
        with open(readme_path, 'r') as f, open('${autogit_global_a[set303h]:-index.html}', 'w') as h:
            h.write(f\"<html><head><title>${autogit_global_a[set303b]}</title></head><body>{markdown.markdown(f.read())}</body></html>\")
        print('${autogit_global_a[set303h]:-index.html} created successfully.')
    elif os.path.exists('${autogit_global_a[set303h]:-index.html}'):
        echo 'HTML file already exists. Skipping creation.'
    else:
        print('README.md not found. Cannot create ${autogit_global_a[set303h]:-index.html}.')
" && fun_echo "HTML page created from README.md!" "🌐" 35
}

# Update kigit.txt with current settings
update_kigit_txt() {
    local config_file=kigit.txt
    local temp_file=$(mktemp)
    while IFS= read -r line; do
        if [[ $line =~ ^[[:space:]]*set303[a-z]= ]]; then
            key=$(echo "$line" | cut -d'=' -f1 | tr -d '[:space:]')
            if [[ ${autogit_global_a[$key]} != force:* ]]; then
                echo "$key=${autogit_global_a[$key]:-}" >> "$temp_file"
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