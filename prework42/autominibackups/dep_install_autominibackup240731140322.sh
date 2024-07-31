#!/bin/bash

# Install GitHub CLI
if ! command -v gh &> /dev/null; then
    echo "GitHub CLI not found, installing..."
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo apt update
        sudo apt install gh -y
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew install gh
    else
        echo "Unsupported OS for automatic installation. Please install GitHub CLI manually."
        exit 1
    fi
else
    echo "GitHub CLI is already installed."
fi
