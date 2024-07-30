#!/bin/bash

# Include functions from functions.sh
source functions.sh

# Developer mode and core directory check
developer_mode_file=kigit_UNICORN_MOOSE_DEVELOPER_MODE_CONFIG.txt
developer_mode=n
main_script_file="auto_git_unicorn_moose_feather_light_windmill_4_bash.sh"
YES_THIS_IS_THE_UNICORN_MOOSE_HOLY_MOLY_CORE_DIR=n

if [[ -f "$main_script_file" ]]; then
    source "$developer_mode_file"
    developer_mode=$(grep -E '^kigit_UNICORN_MOOSE_DEVELOPER_MODE_CONFIG=' "$developer_mode_file" | cut -d'=' -f2)
fi

if [[ -f "$main_script_file" ]]; then
    YES_THIS_IS_THE_UNICORN_MOOSE_HOLY_MOLY_CORE_DIR=y
fi

# Fun greetings and initialization
fun_echo "Welcome to the Auto Git Unicorn Moose Feather Light Windmill Script! 🦄🦌💨" "🎉" 35
fun_echo "Running: $(basename "$0")" "📂" 36

# Ensure we're in a Git repo or create one if not
[[ $(git rev-parse --is-inside-work-tree 2>/dev/null) ]] || {
    fun_echo "No Git repository detected. Initializing a new Git repo..." "🌟" 33
    git init
    fun_echo "Initialized a new Git repository!" "🌟" 33
}

# Fetch GitHub token with flair
fetch_github_token

# Read or create kigit.txt with pizzazz
read_kigit_config

# Change ownership with style
change_ownership

# Setup Git repository with flair
setup_git

# Ensure the correct branch with style
ensure_branch

# Handle repository
handle_repository

# Update files based on config with flair
update_files

# Sync changes with GitHub in style
sync_repo

# Create HTML page if needed with pizzazz
create_html_page

# Update kigit.txt with current settings
update_kigit_txt

# Create g_first_run.py only if in the main directory or developer mode is enabled
create_g_first_run

fun_echo "Script executed successfully! Have a magical day! 🌈✨" "🎉" 36
# Cleanup and unset global array at the end of the script
unset autogit_global_a