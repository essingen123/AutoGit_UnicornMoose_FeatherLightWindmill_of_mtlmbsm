#!/bin/bash

# Function to list search options
list_options() {
    echo "Search options:"
    echo "1. Git history"
    echo "2. VSCode file history"
    echo "3. Current directory files"
    echo "4. All of the above"
    echo "5. Exit"
}

# Prompt user for phrase
read -p "Enter the phrase to search for: " PHRASE

# Function to search Git history
search_git() {
    echo "Searching Git history..."
    git log -p -i -S "$PHRASE" --format=%H | while read commit; do
        echo "Found in commit: $commit"
        git show $commit | grep -i -n --color "$PHRASE"
        echo
    done
}

# Function to search VSCode history
search_vscode() {
    echo "Searching VSCode file history..."
    VSCODE_HISTORY_DIR="$HOME/.config/Code/User/History"
    if [ ! -d "$VSCODE_HISTORY_DIR" ]; then
        VSCODE_HISTORY_DIR="$HOME/.vscode-server/data/User/History"
    fi
    if [ -d "$VSCODE_HISTORY_DIR" ]; then
        find "$VSCODE_HISTORY_DIR" -type f -print0 | 
        while IFS= read -r -d '' file; do
            echo -ne "\rSearching: ${file##*/}"
            if grep -q -i "$PHRASE" "$file"; then
                echo
                echo "Found in: $file"
                grep -i -n --color "$PHRASE" "$file"
                echo
            fi
        done
        echo
    else
        echo "VSCode history directory not found."
    fi
}

# Function to search current directory
search_current_dir() {
    echo "Searching current directory files..."
    find . -type f -print0 | 
    while IFS= read -r -d '' file; do
        echo -ne "\rSearching: ${file##*/}"
        if grep -q -i "$PHRASE" "$file"; then
            echo
            echo "Found in: $file"
            grep -i -n --color "$PHRASE" "$file"
            echo
        fi
    done
    echo

    echo "Searching for phrase in quotes within .sh files..."
    find . -name "*.sh" -type f -print0 | 
    while IFS= read -r -d '' file; do
        echo -ne "\rSearching: ${file##*/}"
        if grep -q -i -E "\"[^\"]*$PHRASE[^\"]*\"" "$file"; then
            echo
            echo "Found in quotes in: $file"
            grep -i -n --color -E "\"[^\"]*$PHRASE[^\"]*\"" "$file"
            echo
        fi
    done
    echo
}

# Main loop
while true; do
    list_options
    read -p "Enter your choice (1-5): " CHOICE

    case $CHOICE in
        1) search_git ;;
        2) search_vscode ;;
        3) search_current_dir ;;
        4)
            search_git
            search_vscode
            search_current_dir
            ;;
        5)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option. Please try again."
            ;;
    esac

    echo "Search completed."
    echo
done