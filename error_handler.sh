#!/bin/bash

handle_error() {
    local error_message="$1"
    echo "Error: $error_message"
    exit 1
}
