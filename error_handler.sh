#!/bin/bash

# Error handler
log() {
    if [ "$verbose" == "y" ]; then
        echo "$1"
    fi
}
