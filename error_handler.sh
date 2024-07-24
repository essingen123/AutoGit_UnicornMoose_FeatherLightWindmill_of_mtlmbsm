#!/bin/bash

handle_error() {
    local error_message="$1"
    echo "Error: $error_message"
    # DO NOT EXIT UPON ERROR CONTINUE INSTEAD :) exit 1
}
