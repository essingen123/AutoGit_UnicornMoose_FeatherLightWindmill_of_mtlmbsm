#!/bin/bash

# Configuration handler
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
                    echo "VERBOSE SET :"
                    read -r next_line
                    verbose="${next_line}"
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
}
