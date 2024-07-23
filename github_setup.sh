#!/bin/bash

# GitHub setup
setup_github_repo() {
    local dir="$1"
    add_alias_to_bashrc
    check_github_token

    if [ ! -d "$dir/.git" ]; then
        git init "$dir"
        log "Git repository initialized."
    fi

    if [ ! -f "$dir/.gitignore" ]; then
        log "No .gitignore file found. Creating one."
        cat <<EOL > "$dir/.gitignore"
# Ignore OS-specific files
.DS_Store
Thumbs.db

# Ignore IDE files
*.iml
.idea
.vscode

# Ignore sensitive files
.env
*.pem
.git_very_secret_and_ignored_file_token

# Ignore log and build files
*.log
build/
dist/
*.o
*.exe
*.dll
*.so
EOL
        git -C "$dir" add .gitignore
        git -C "$dir" commit -m "Add .gitignore"
    fi

    repo_exists=$(gh repo view "$repo_name" --json name --jq '.name' 2>/dev/null)
    if [ -z "$repo_exists" ]; then
        gh repo create "$repo_name" $visibility --enable-issues --enable-wiki
    else
        log "Repository already exists."
    fi

    git -C "$dir" add .
    git -C "$dir" commit -m "${1:-Syncing changes with GitHub}"
    git -C "$dir" push --set-upstream origin master
    git -C "$dir" push origin master
}
