
#Processing file: ./auto_git_unicorn_moose_feather_light_windmill_4_bash.sh

#!/bin/bash

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

# Prompt for GitHub token and update a hidden file if needed
check_github_token() {
    local token_file="$HOME/.git_very_secret_and_ignored_file_token"
    if [ ! -f "$token_file" ]; then
        log "GitHub token not found in your environment."
        read -p "Would you like to enter your GitHub token? (It will be saved in a hidden file for future sessions) (y/n) " yn
        if [[ "$yn" == "y" ]]; then
            read -s -p "Enter your GitHub token: " token
            echo
            echo "$token" > "$token_file"
            chmod 600 "$token_file"
            log "GitHub token set for this session and saved for future sessions."
        else
            log "GitHub token is required. Exiting."
            exit 1
        fi
    else
        log "GitHub token is already set."
    fi
}

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
y

# 📝# git-reponame, leave next line as random and it will be random word otherwise write a github repo name in 
# set303b
AutoGit_UnicornMoose_FeatherLightWindmill_of_mtlmbsm

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

# Function to setup GitHub repository
setup_github_repo() {
    add_alias_to_bashrc
    check_github_token

    # Initialize git if not already initialized
    if [ ! -d ".git" ]; then
        git init
        log "Git repository initialized."
    fi

    # Create or update .gitignore
    if [ ! -f ".gitignore" ]; then
        log "No .gitignore file found. Would you like to create one? (y/n)"
        read create_ignore
        if [[ "$create_ignore" == "y" ]]; then
            touch .gitignore
            log "Creating .gitignore with common patterns."
            echo "# Ignore OS-specific files" >> .gitignore
            echo ".DS_Store" >> .gitignore
            echo "Thumbs.db" >> .gitignore

            echo "# Ignore IDE files" >> .gitignore
            echo "*.iml" >> .gitignore
            echo ".idea" >> .gitignore
            echo ".vscode" >> .gitignore

            echo "# Ignore sensitive files" >> .gitignore
            echo ".env" >> .gitignore
            echo "*.pem" >> .gitignore
            echo ".git_very_secret_and_ignored_file_token" >> .gitignore

            echo "# Ignore log and build files" >> .gitignore
            echo "*.log" >> .gitignore
            echo "build/" >> .gitignore
            echo "dist/" >> .gitignore
            echo "*.o" >> .gitignore
            echo "*.exe" >> .gitignore
            echo "*.dll" >> .gitignore
            echo "*.so" >> .gitignore

            git add .gitignore
            git commit -m "Add .gitignore"
        fi
    else
        if ! grep -q ".git_very_secret_and_ignored_file_token" .gitignore; then
            echo ".git_very_secret_and_ignored_file_token" >> .gitignore
            git add .gitignore
            git commit -m "Update .gitignore to include .git_very_secret_and_ignored_file_token"
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
    git commit -m "${1:-Syncing changes with GitHub}"
    git push --set-upstream origin master
    git push origin master
}

# Function to update the README file
update_readme() {
    if [ -f README.md ]; then
        log "Updating README.md file."
        echo "# ${repo_name}" > README.md
        echo "Updated project description:"
        read updated_project_description
        echo "${updated_project_description}" >> README.md
        echo "" >> README.md
        echo "This project is licensed under the MIT License." >> README.md
        echo "Definition of MTLMBSM: Meh To Less Meh But Still Meh." >> README.md
        echo "![Auto Git Unicorn Moose Feather Light Windmill](auto_git_unicorn_moose_feather_light_windmill_of_mtlmbsm.webp)" >> README.md
        git add README.md
        git commit -m "Update README file"
        git push origin master
    fi
}

# Function to generate a neat webpage for the GitHub project
generate_html_page() {
    log "Generating HTML page from README.md..."
    python3 "${script_dir}/_extra_bonus.py"
}

# Add or update README file
if [ ! -f README.md ]; then
    log "No README.md found. Would you like to create one? (y/n)"
    read create_readme
    if [[ "$create_readme" == "y" ]]; then
        log "Creating README.md file."
        echo "# ${repo_name}" > README.md
        echo "Enter a short project description:"
        read project_description
        echo "${project_description}" >> README.md
        echo "" >> README.md
        echo "This project is licensed under the MIT License." >> README.md
        echo "Definition of MTLMBSM: Meh To Less Meh But Still Meh." >> README.md
        echo "![Auto Git Unicorn Moose Feather Light Windmill](auto_git_unicorn_moose_feather_light_windmill_of_mtlmbsm.webp)" >> README.md
        git add README.md
        git commit -m "Add README file"
        git push origin master
    fi
fi

if [ "$update_flag" == "y" ]; then
    # Reset the update flag in kigit.txt to 'n' after updates
    sed -i 's/update according to this file=y/update according to this file=n/' "$config_file"

    log "Git sync unicorn moose blazing away a turn in that windmill party! 🎉"
fi

# Function to sync the repository
sync_github_repo() {
    # Add all files and commit
    git add .
    git commit -m "${1:-Syncing changes with GitHub}"
    git push origin master
}

# Main logic
read_config

# Proceed with setup if .git does not exist or based on update flag
if [ ! -d ".git" ]; then
    log "Git is not initialized. Proceeding to setup the repository."
    setup_github_repo "$@"
else
    log "Git is already initialized."
    if [ "$update_flag" == "y" ]; then
        log "Update flag is set to 'y'. Proceeding to setup the repository."
        setup_github_repo "$@"
    else
        log "Update flag set to 'n'. Syncing repository."
        sync_github_repo "$@"
    fi
fi

# Check and potentially generate the HTML page
if [ "$auto_page_trigger" = true ] || [ ! -f "index.html" ]; then
    log "index.html not found or auto page generation enabled. Generating HTML page from README.md..."
    generate_html_page
else
    log "If you wish to also have that cool HTML page, you can run the following command to generate a neat webpage for your GitHub project: ./_extra_bonus.py"
fi

# Update the About section
python3 "${script_dir}/update_github_about.py"

# Set the GitHub Pages URL as the homepage of the repository
github_username=$(git config user.name)
repo_url=$(git config --get remote.origin.url)
repo_name=$(basename "$repo_url" .git)
log "Determined GitHub Username: $github_username"
log "Determined Repo Name: $repo_name"
if [ -n "$github_username" ] && [ -n "$repo_name" ]; then
    log "Setting GitHub Pages URL as the homepage for the repository..."
    log "API Call: gh api -X PATCH repos/$github_username/$repo_name -f homepage=https://$github_username.github.io/$repo_name"
    if [ "$verbose" == "y" ]; then
        gh api -X PATCH repos/$github_username/$repo_name -f homepage="https://$github_username.github.io/$repo_name"
    else
        gh api -X PATCH repos/$github_username/$repo_name -f homepage="https://$github_username.github.io/$repo_name" >/dev/null 2>&1
    fi
    log "GitHub Pages URL set as the homepage for the repository."
else
    log "Could not determine GitHub username or repository name. Skipping homepage URL update."
fi

#Processing file: ./a__COLLECTED_SH_FILES.sh


#Processing file: ./dep_install.sh

#!/bin/bash

# Install GitHub CLI
if ! command -v gh &> /dev/null; then
    echo "GitHub CLI not found, installing..."
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo apt update
        sudo apt install gh -y
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew install gh
    else
        echo "Unsupported OS for automatic installation. Please install GitHub CLI manually."
        exit 1
    fi
else
    echo "GitHub CLI is already installed."
fi

#Processing file: ./auto_commit_push.sh

#!/bin/bash

# Run the main script with a default commit message if no arguments are provided
if [ -z "$1" ]; then
    commit_message="Auto-commit by cron job"
else
    commit_message="$1"
fi

# Execute the 'g' alias with the commit message
g "$commit_message"
