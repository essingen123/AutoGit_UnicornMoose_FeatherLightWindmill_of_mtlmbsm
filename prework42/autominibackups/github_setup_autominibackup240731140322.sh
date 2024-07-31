#!/bin/bash

# GitHub setup operations
setup_github_repo() {
    local dir="$1"
    add_alias_to_bashrc
    check_github_token

    # Initialize git if not already initialized
    if [ ! -d "$dir/.git" ]; then
        git init "$dir"
        log "Git repository initialized."
    fi

    # Create or update .gitignore
    if [ ! -f "$dir/.gitignore" ]; then
        log "No .gitignore file found. Creating one."
        touch "$dir/.gitignore"
        echo "# Ignore OS-specific files" >> "$dir/.gitignore"
        echo ".DS_Store" >> "$dir/.gitignore"
        echo "Thumbs.db" >> "$dir/.gitignore"

        echo "# Ignore IDE files" >> "$dir/.gitignore"
        echo "*.iml" >> "$dir/.gitignore"
        echo ".idea" >> "$dir/.gitignore"
        echo ".vscode" >> "$dir/.gitignore"

        echo "# Ignore sensitive files" >> "$dir/.gitignore"
        echo ".env" >> "$dir/.gitignore"
        echo "*.pem" >> "$dir/.gitignore"
        echo ".git_very_secret_and_ignored_file_token" >> "$dir/.gitignore"

        echo "# Ignore log and build files" >> "$dir/.gitignore"
        echo "*.log" >> "$dir/.gitignore"
        echo "build/" >> "$dir/.gitignore"
        echo "dist/" >> "$dir/.gitignore"
        echo "*.o" >> "$dir/.gitignore"
        echo "*.exe" >> "$dir/.gitignore"
        echo "*.dll" >> "$dir/.gitignore"
        echo "*.so" >> "$dir/.gitignore"

        git add "$dir/.gitignore"
        git commit -m "Add .gitignore" -C "$dir"
    else
        if ! grep -q ".git_very_secret_and_ignored_file_token" "$dir/.gitignore"; then
            echo ".git_very_secret_and_ignored_file_token" >> "$dir/.gitignore"
            git add "$dir/.gitignore"
            git commit -m "Update .gitignore to include .git_very_secret_and_ignored_file_token" -C "$dir"
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
    git commit -m "$commit_message" -C "$dir"
    git push --set-upstream origin "$branch" -C "$dir"
    git push origin "$branch" -C "$dir"
}
