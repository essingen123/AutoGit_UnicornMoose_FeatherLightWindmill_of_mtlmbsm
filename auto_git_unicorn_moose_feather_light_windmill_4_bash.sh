#!/bin/bash

# filename:
# auto_git_unicorn_moose_feather_light_windmill_4_bash.sh

# Path for the script
script_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "$0")"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to update .bashrc with new alias or environment variable
update_bashrc() {
    local entry="$1"
    local file="$HOME/.bashrc"
    echo "Updating .bashrc with entry: $entry"

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
    echo "Adding alias to .bashrc: $alias_cmd"
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
            if [[ "$line" =~ ^# ]]; then
                continue
            fi
            if [[ "$line" == *=* ]]; then
                key="${line%%=*}"
                value="${line#*=}"
                case "$key" in
                    "set303a update according to this file")
                        update_flag="${value// /}"
                        ;;
                    "set303b git-reponame")
                        repo_name="${value// /}"
                        ;;
                    "set303c public git")
                        public="${value// /}"
                        ;;
                    "set303d auto generate HTML page")
                        auto_page="${value// /}"
                        ;;
                    "set303e tags")
                        tags="$value"
                        ;;
                    "set303f description")
                        description="$value"
                        ;;
                    "set303g website URL")
                        website="${value// /}"
                        ;;
                    "set303i Verbose")
                        verbose="${value// /}"
                        ;;
                esac
            fi
        done < "$config_file"
    else
        echo "No kigit.txt file found. Configuration is required. Exiting."
        exit 1
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
        echo "Git repository initialized."
    fi

    # Create or update .gitignore
    if [ ! -f ".gitignore" ]; then
        echo "No .gitignore file found. Would you like to create one? (y/n)"
        read create_ignore
        if [[ "$create_ignore" == "y" ]]; then
            touch .gitignore
            echo "Creating .gitignore with common patterns."
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
        echo "Repository already exists. Fetching current description."
        current_description=$(gh api repos/"$github_username"/"$repo_name" --jq .description)
        if [ -n "$current_description" ] && ! grep -q "set303f description" "$config_file"; then
            echo "set303f description=$current_description" >> "$config_file"
            echo "Updated kigit.txt with current repository description."
        fi
    fi

    # Add all files and commit
    git add .
    git commit -m "Syncing changes with GitHub"
    git push --set-upstream origin master
    git push origin master
}

# Function to update the README file
update_readme() {
    if [ -f README.md ]; then
        echo "Updating README.md file."
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
    echo "Generating HTML page from README.md..."
    python3 "${script_dir}/_extra_bonus.py"
}

# Add or update README file
if [ ! -f README.md ]; then
    echo "No README.md found. Would you like to create one? (y/n)"
    read create_readme
    if [[ "$create_readme" == "y" ]]; then
        echo "Creating README.md file."
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

    echo "Git sync unicorn moose blazing away a turn in that windmill party! 🎉"
fi

# Function to sync the repository
sync_github_repo() {
    # Add all files and commit
    git add .
    git commit -m "Syncing changes with GitHub"
    git push origin master
}

log() {
    if [ "$verbose" == "y" ]; then
        echo "$1"
    fi
}

# Main logic
read_config

# Proceed with setup if .git does not exist or based on update flag
if [ ! -d ".git" ]; then
    echo "Git is not initialized. Proceeding to setup the repository."
    setup_github_repo
else
    log "Git is already initialized."
    if [ "$update_flag" == "y" ]; then
        echo "Update flag is set to 'y'. Proceeding to setup the repository."
        setup_github_repo
    else
        log "Update flag set to 'n'. Syncing repository."
        sync_github_repo
    fi
fi

# Check and potentially generate the HTML page
if [ "$auto_page_trigger" = true ] || [ ! -f "index.html" ]; then
    echo "index.html not found or auto page generation enabled. Generating HTML page from README.md..."
    python3 "${script_dir}/_extra_bonus.py"
else
    echo "If you wish to also have that cool HTML page, you can run the following command to generate a neat webpage for your GitHub project: ./_extra_bonus.py"
fi

# Update the About section
python3 "${script_dir}/update_github_about.py"

# Set the GitHub Pages URL as the homepage of the repository
github_username=$(git config user.name)
repo_url=$(git config --get remote.origin.url)
repo_name=$(basename "$repo_url" .git)

echo "Determined GitHub Username: $github_username"
echo "Determined Repo Name: $repo_name"

if [ -n "$github_username" ] && [ -n "$repo_name" ]; then
    echo "Setting GitHub Pages URL as the homepage for the repository..."
    echo "API Call: gh api -X PATCH repos/$github_username/$repo_name -f homepage=https://$github_username.github.io/$repo_name"
    gh api -X PATCH repos/$github_username/$repo_name -f homepage="https://$github_username.github.io/$repo_name"
    log "GitHub Pages URL set as the homepage for the repository."
else
    echo "Could not determine GitHub username or repository name. Skipping homepage URL update."
fi
