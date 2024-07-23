#!/bin/bash
import os
import subprocess

# Define the kigit.txt content
kigit_content = """# This is a config file for the auto_git_unicorn_moose_feather .. 🦄
# File: kigit.txt

# 💻
# update according to this file 
# set303a 
y

# 📝# git-reponame, leave next line as random and it will be random word otherwise write a github repo name in 
# set303b
random

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
y
# DONT EDIT OUT THIS LAST LINE
"""

# Create kigit.txt if it does not exist in the project directory
project_dir = os.getcwd()
kigit_path = os.path.join(project_dir, "kigit.txt")

if not os.path.exists(kigit_path):
    with open(kigit_path, "w") as file:
        file.write(kigit_content)
    print("kigit.txt created with default configuration.")

# Ensure the alias 'g' is correctly set in the user's .bashrc
bashrc_path = os.path.expanduser("~/.bashrc")

with open(bashrc_path, "r") as file:
    bashrc_content = file.readlines()

# Remove any existing 'g' alias definitions
bashrc_content = [line for line in bashrc_content if not line.startswith("alias g=")]

# Add the new 'g' alias definition
bashrc_content.append(f"alias g='{os.path.join(project_dir, 'auto_git_unicorn_moose_feather_light_windmill_4_bash.sh')}'\n")

with open(bashrc_path, "w") as file:
    file.writelines(bashrc_content)

print("Alias 'g' added to .bashrc.")

# Source the updated .bashrc
subprocess.run(["source ~/.bashrc"], shell=True, check=True)

print("Sourced the updated .bashrc successfully.")

# Configuration handler
read_config() {

#!/bin/sh

kigit_content="# This is a config file for the auto_git_unicorn_moose_feather .. 🦄
# File: kigit.txt

# 💻
# update according to this file 
# set303a 
y

# 📝# git-reponame, leave next line as random and it will be random word otherwise write a github repo name in 
# set303b
random

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
y
# DONT EDIT OUT THIS LAST LINE"

if [ ! -f "kigit.txt" ]; then
    echo "$kigit_content" > kigit.txt
    echo "kigit.txt created with default configuration."
fi

    
    config_file="${script_dir}/kigit.txt"
    update_flag="n"
    repo_name="random"
    public="n"
    auto_page="n"
    tags=""
    description=""
    website=""
    verbose="n"
    branch="main"
    commit_message="Syncing changes with GitHub"

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
                *"set303j"*)
                    read -r next_line
                    branch="${next_line}"
                    ;;
                *"set303k"*)
                    read -r next_line
                    commit_message="${next_line}"
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
trailblazer_ai_project

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

# 🌳
# Branch to commit to, 'main' or a new branch name
# set303j
main

# 💬
# Default commit message
# set303k
This is my standard commit message to save time: Hmm.. just look at the data to reveal the updates

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
