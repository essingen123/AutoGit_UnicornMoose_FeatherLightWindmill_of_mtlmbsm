#!/bin/bash

# Run the main script with a default commit message if no arguments are provided
if [ -z "$1" ]; then
    commit_message="Auto-commit by cron job"
else
    commit_message="$1"
fi

# Execute the 'g' alias with the commit message
g "$commit_message"
