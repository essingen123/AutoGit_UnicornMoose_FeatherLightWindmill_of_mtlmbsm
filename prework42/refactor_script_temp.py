main_script = "auto_git_unicorn_moose_feather_light_windmill_4_bash.sh"
config_handler = "config_handler.sh"
error_handler = "error_handler.sh"
github_setup = "github_setup.sh"
git_operations = "git_operations.sh"
bashrc_update = "bashrc_update.sh"

with open(main_script, 'w') as f:
    f.write(f"""#!/bin/bash

# Main script to orchestrate other scripts
# Include other scripts
source ./{config_handler}
source ./{error_handler}
source ./{github_setup}
source ./{git_operations}
source ./{bashrc_update}

# Main script logic
read_config
if [ ! -d ".git" ]; then
    log "Git is not initialized. Proceeding to setup the repository."
    setup_github_repo
else
    log "Git is already initialized."
    if [ "$update_flag" == "y" ]; then
        log "Update flag is set to 'y'. Proceeding to setup the repository."
        setup_github_repo
    else
        log "Update flag set to 'n'. Syncing repository."
        sync_github_repo
    fi
fi

if [ "$auto_page_trigger" = true ] || [ ! -f "index.html" ]; then
    log "index.html not found or auto page generation enabled. Generating HTML page from README.md..."
    generate_html_page
else
    log "If you wish to also have that cool HTML page, you can run the following command to generate a neat webpage for your GitHub project: ./_extra_bonus.py"
fi

update_github_about
""")

with open(config_handler, 'w') as f:
    f.write(f"""#!/bin/bash

# Configuration handler
read_config() {{
    config_file="${{script_dir}}/kigit.txt"
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
                    update_flag="${{next_line}}"
                    ;;
                *"set303b"*)
                    read -r next_line
                    repo_name="${{next_line}}"
                    ;;
                *"set303c"*)
                    read -r next_line
                    public="${{next_line}}"
                    ;;
                *"set303d"*)
                    read -r next_line
                    auto_page="${{next_line}}"
                    ;;
                *"set303e"*)
                    read -r next_line
                    tags="${{next_line}}"
                    ;;
                *"set303f"*)
                    read -r next_line
                    description="${{next_line}}"
                    ;;
                *"set303g"*)
                    read -r next_line
                    website="${{next_line}}"
                    ;;
                *"set303i"*)
                    echo "VERBOSE SET :"
                    read -r next_line
                    verbose="${{next_line}}"
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
}}
""")

with open(error_handler, 'w') as f:
    f.write(f"""#!/bin/bash

# Error handler
log() {{
    if [ "$verbose" == "y" ]; then
        echo "$1"
    fi
}}
""")

with open(github_setup, 'w') as f:
    f.write(f"""#!/bin/bash

# GitHub setup
setup_github_repo() {{
    add_alias_to_bashrc
    check_github_token

    if [ ! -d ".git" ]; then
        git init
        log "Git repository initialized."
    fi

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

    git add .
    git commit -m "Syncing changes with GitHub"
    git push --set-upstream origin master
    git push origin master
}}
""")

with open(git_operations, 'w') as f:
    f.write(f"""#!/bin/bash

# Git operations
sync_github_repo() {{
    git add .
    git commit -m "Syncing changes with GitHub"
    git push origin master
}}

generate_html_page() {{
    log "Generating HTML page from README.md..."
    python3 "${{script_dir}}/_extra_bonus.py"
}}

update_github_about() {{
    python3 "${{script_dir}}/update_github_about.py"
}}
""")

with open(bashrc_update, 'w') as f:
    f.write(f"""#!/bin/bash

# .bashrc update
update_bashrc() {{
    local entry="$1"
    local file="$HOME/.bashrc"
    log "Updating .bashrc with entry: $entry"

    if ! grep -qF "$entry" "$file"; then
        echo "$entry" >> "$file"
        log "Added $entry to $file"
    else
        log "$entry already exists in $file"
    fi
}}

add_alias_to_bashrc() {{
    local alias_cmd="alias g='${{script_path}}'"
    log "Adding alias to .bashrc: $alias_cmd"
    update_bashrc "$alias_cmd"
    log "Alias 'g' added to .bashrc. Please restart your terminal or source ~/.bashrc."
}}

check_github_token() {{
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
}}
""")

print(f"Scripts {main_script}, {config_handler}, {error_handler}, {github_setup}, {git_operations}, and {bashrc_update} have been generated successfully.")
