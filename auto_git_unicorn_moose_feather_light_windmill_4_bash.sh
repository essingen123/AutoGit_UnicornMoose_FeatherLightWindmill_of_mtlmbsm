#!/bin/bash
set -e

handle_error() {
    local error_code=$?
    local last_command=$(history 1 | sed 's/^ *[0-9]* *//')
    echo "An error occurred in the command: '$last_command' (exit code: $error_code). Would you like to quit (q) or proceed (p)?"
    read -r choice
    case "$choice" in
        q|Q) exit 1 ;;
        p|P) return 0 ;;
        *) echo "Invalid choice. Exiting." ; exit 1 ;;
    esac
}

trap 'handle_error' ERR

echo "Running file: $(basename "$0")"
echo "Script path: $(dirname "$0")/${0##*/}"
echo "Script directory: $(dirname "$0")"

script_path=$(dirname "$0")/${0##*/}
script_dir=$(dirname "$0")
config_file="$script_dir/kigit.txt"
token_file="$HOME/.git_token_secret"

echo "Configuration file path: $config_file"
echo "Token file path: $token_file"

log() { [ "$verbose" == "y" ] && echo "$1"; }
error() { echo "Error: $1" >&2; exit 1; }

echo "Fetching GitHub token..."
fetch_github_token() {
    [ -f "$token_file" ] && cat "$token_file" || {
        log "GitHub token not found. Please provide your GitHub token."
        read -sp "Enter GitHub token: " token
        echo "$token" > "$token_file"
        chmod 600 "$token_file"
    }
}
fetch_github_token
echo "GitHub token fetched."

echo "Reading kigit configuration..."
read_kigit_config() {
    if [ ! -f "$config_file" ]; then
        initialize_kigit
    fi

    while IFS= read -r line; do
        key=$(echo "$line" | cut -d'=' -f1 | tr -d '[:space:]')
        value=$(echo "$line" | cut -d'=' -f2- | sed 's/^[[:space:]]*//')
        case "$key" in
            "set303a") update_flag="$value" ;;
            "set303b") repo_name="$value" ;;
            "set303c") public="$value" ;;
            "set303d") auto_page="$value" ;;
            "set303e") tags="$value" ;;
            "set303f") description="$value" ;;
            "set303g") website="$value" ;;
            "set303h") html_file="$value" ;;
            "set303j") branch="$value" ;;
            "set303k") commit_message="$value" ;;
            "set303l") change_ownership="$value" ;;
        esac
    done < "$config_file"
}
read_kigit_config
echo "Configuration read."

change_file_ownership() {
    echo "Changing ownership of all files to $(whoami)..."
    sudo chown -R $(whoami):$(whoami) "$script_dir"
    echo "Ownership changed."
}

if [ "$change_ownership" == "y" ]; then
    change_file_ownership
fi

echo "Setting up Git repository..."
setup_git() {
    [ ! -d ".git" ] && git init
    
    [ ! -f ".gitignore" ] && cat > .gitignore <<EOL
# Ignore OS-specific files
.DS_Store
Thumbs.db
# IDE files
.idea/
.vscode/
# Sensitive files
.env
# Build files
build/
dist/
*.o
*.exe
*.dll
*.so
EOL
    git add .gitignore
    git commit -m "Add .gitignore" || true
}
setup_git
echo "Git repository setup complete."

echo "Creating or updating GitHub repository..."
create_or_update_repo() {
    local repo_name=${repo_name}
    local repo_exists=$(gh repo view "$repo_name" --json name --jq '.name' 2>/dev/null)
    
    if [ -z "$repo_exists" ]; then
        echo "Creating GitHub repository: $repo_name"
        gh repo create "$repo_name" --${public} --enable-issues --enable-wiki || error "Failed to create GitHub repository"
    else
        log "Repository $repo_name already exists."
    fi
}
create_or_update_repo
echo "GitHub repository created or updated."

echo "Ensuring Git branch..."
ensure_branch() {
    git checkout -b "$branch" 2>/dev/null || git checkout "$branch"
}
ensure_branch
echo "Git branch ensured."

echo "Updating files..."
update_files() {
    local force_update=0
    [ "$update_flag" == "y" ] && force_update=1
    
    if [ ! -f README.md ] || [ "$force_update" -eq 1 ]; then
        cat > README.md <<EOL
# $repo_name
$description

Tags: $tags
EOL
        git add README.md
        git commit -m "Update README.md" || true
    fi

    if [ "$auto_page" == "y" ] && [ ! -f "$html_file" ] || [ "$force_update" -eq 1 ]; then
        cat > "$html_file" <<EOL
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>$repo_name</title>
</head>
<body>
    <h1>$repo_name</h1>
    <p>$description</p>
</body>
</html>
EOL
        git add "$html_file"
        git commit -m "Add $html_file" || true
    fi
}
update_files
echo "Files updated."

echo "Syncing repository..."
sync_repo() {
    local commit_msg="$commit_message"
    commit_msg="${commit_msg//\~date/$(date +%Y%m%d%H%M%S)}"
    commit_msg="${commit_msg//\~data/$(git status --porcelain | wc -l) files changed}"
    
    git add .
    git commit -m "$commit_msg" || true
    git push origin "$branch"
}
sync_repo
echo "Repository synced."

echo "Setting up alias..."
setup_alias() {
    local alias_line="alias g='${script_path}'"
    grep -qF "$alias_line" ~/.bashrc || echo "$alias_line" >> ~/.bashrc
    log "Added alias to .bashrc. Please run 'source ~/.bashrc' to update the shell."
}
setup_alias
echo "Alias setup complete."

echo "Creating HTML page..."
create_html_page() {
    python3 - <<EOF
import os
import markdown
if os.path.exists("README.md"):
    with open("README.md", 'r') as readme_file:
        readme_content = readme_file.read()
    html = markdown.markdown(readme_content)
    with open(os.path.join(os.path.dirname(os.path.realpath(__file__)), 'index.html'), 'w') as html_file:
        html_file.write(f"<html><head><title>Repository Info</title></head><body>{html}</body></html>")
    print("index.html created successfully.")
else:
    print("README.md not found. Cannot create index.html.")
EOF
}
create_html_page
echo "HTML page created."

log "Script execution completed."
