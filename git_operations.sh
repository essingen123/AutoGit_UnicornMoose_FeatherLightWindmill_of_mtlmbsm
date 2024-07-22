#!/bin/bash

# Git operations
sync_github_repo() {
    git add .
    git commit -m "Syncing changes with GitHub"
    git push origin master
}

generate_html_page() {
    log "Generating HTML page from README.md..."
    python3 "${script_dir}/_extra_bonus.py"
}

update_github_about() {
    python3 "${script_dir}/update_github_about.py"
}
