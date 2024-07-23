#!/bin/bash

# Git operations
sync_github_repo() {
    local dir="$1"
    git -C "$dir" add .
    git -C "$dir" commit -m "Syncing changes with GitHub"
    git -C "$dir" push origin master
}

generate_html_page() {
    local dir="$1"
    log "Generating HTML page from README.md..."
    python3 "$dir/_extra_bonus.py"
}

update_github_about() {
    local dir="$1"
    python3 "$dir/update_github_about.py"
}
