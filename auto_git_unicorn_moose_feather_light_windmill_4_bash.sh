#!/bin/bash

# Path for the script
script_path="$(pwd)/$(basename "$0")"

# Function to update .bashrc with new alias or environment variable
update_bashrc() {
    local entry="$1"
    local file="$HOME/.bashrc"

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

# Function to read the configuration file
read_config() {
    config_file="kigit.txt"
    update_flag="n"
    repo_name="random"
    public="n"
    auto_page="n"
    tags=""
    description=""
    website=""

    if [ -f "$config_file" ]; then
        while IFS= read -r line; do
            if [[ "$line" =~ ^# ]]; then
                continue
            fi
            if [[ "$line" == *=* ]]; then
                key="${line%%=*}"
                value="${line#*=}"
                case "$key" in
                    "update according to this file")
                        update_flag="${value// /}"
                        ;;
                    "git-reponame")
                        repo_name="${value// /}"
                        ;;
                    "public git")
                        public="${value// /}"
                        ;;
                    "auto generate HTML page")
                        auto_page="${value// /}"
                        ;;
                    "tags")
                        tags="$value"
                        ;;
                    "description")
                        description="$value"
                        ;;
                    "website URL")
                        website="${value// /}"
                        ;;
                esac
            fi
        done < "$config_file"
    else
        echo "No kigit.txt file found. Would you like to create it? (y/n)"
        read create_kigit
        if [ "$create_kigit" == "y" ]; then
            cat <<EOL > kigit.txt
#update according to this file
y
#git-reponame, leave next line as random and it will be random word otherwise write a github repo name in
random
#public git, y for yes n for no, standard no
n
#auto generate HTML page, y for yes n for no
y
#tags, separated by commas
Python, Bash Clash, Bash, Automation, Automagic, un-PEP8-perhaps
#description
Making x less meh for those that perceives a meh really real, so the purpose of this repo is simply to make a move in the direction of a meh-factor-compensatory-instigator. x=git
#website URL
http://example.com
#GithubPartywebpageLink
index.html
EOL
            echo "Created kigit.txt. Please edit this file and re-run the script."
            exit 0
        else
            echo "kigit.txt is required for configuration. Exiting."
            exit 1
        fi
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
    read_config
    add_alias_to_bashrc
    check_github_token

    if [ "$update_flag" == "n" ]; then
        echo "Configuration file update flag is set to 'n'. No updates will be made."
        return
    fi

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
    fi

    # Add all files and commit
    git add .
    git commit -m "Initial commit: Setting up GitHub repository"
    git remote add origin "https://github.com/$(git config user.name)/${repo_name}.git"
    git push --set-upstream origin master
    git push origin master

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

    # Reset the update flag in kigit.txt to 'n' after updates
    sed -i 's/update according to this file=y/update according to this file=n/' kigit.txt

    echo "Git sync unicorn moose blazing away a turn in that windmill party! 🎉"
}

# Main logic
if [ ! -f "kigit.txt" ]; then
    echo "No kigit.txt file found. Would you like to create it? (y/n)"
    read create_kigit
    if [ "$create_kigit" == "y" ]; then
        cat <<EOL > kigit.txt
#update according to this file
y
#git-reponame, leave next line as random and it will be random word otherwise write a github repo name in
random
#public git, y for yes n for no, standard no
n
#auto generate HTML page, y for yes n for no
y
#tags, separated by commas
Python, Bash Clash, Bash, Automation, Automagic, un-PEP8-perhaps
#description
Making x less meh for those that perceives a meh really real, so the purpose of this repo is simply to make a move in the direction of a meh-factor-compensatory-instigator. x=git
#website URL
http://example.com
#GithubPartywebpageLink
index.html
EOL
        echo "Created kigit.txt. Please edit this file and re-run the script."
        exit 0
    else
        echo "kigit.txt is required for configuration. Exiting."
        exit 1
    fi
fi

# Always read the configuration file to determine the update behavior
read_config

# Proceed with setup if .git does not exist or based on update flag
if [ ! -d ".git" ]; then
    echo "Git is not initialized. Proceeding to setup the repository."
    setup_github_repo
elif [ "$update_flag" == "y" ]; then
    echo "Update flag is set to 'y'. Proceeding to setup the repository."
    setup_github_repo
else
    echo "Git is already initialized and update flag is set to 'n'. No updates will be made."
fi

# Check and potentially generate the HTML page
if [ "$auto_page_trigger" = true ] || [ ! -f "index.html" ]; then
    echo "index.html not found or auto page generation enabled. Generating HTML page from README.md..."
    python3 _extra_bonus.py
else
    echo "If you wish to also have that cool HTML page, you can run the following command to generate a neat webpage for your GitHub project: ./_extra_bonus.py"
fi

# Update the About section
python3 update_github_about.py

    # Add all files and commit
    git add .
    git commit -m "Initial commit: Setting up GitHub repository"
    git remote add origin "https://github.com/$(git config user.name)/${repo_name}.git"
    git push --set-upstream origin master
    git push origin master