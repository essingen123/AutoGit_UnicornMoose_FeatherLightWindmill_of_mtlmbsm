#!/bin/bash

# Set the backup folder name
BACKUP_FOLDER="autominibackups"

# Set the config file name
CONFIG_FILE="autominibackups_file_watch_config.txt"

# Set the PID file name
PID_FILE="/tmp/autominibackups.pid"

# Function to start the backup process
start_backup() {
    # Create the backup folder if it doesn't exist
    mkdir -p "$BACKUP_FOLDER"

    # Check if the backup folder is writable
    if [ ! -w "$BACKUP_FOLDER" ]; then
        echo "Error: Backup folder '$BACKUP_FOLDER' is not writable."
        exit 1
    fi

    # Check if the config file exists, if not create it
    if [ ! -f "$CONFIG_FILE" ]; then
        echo "# Enter files to watch (one per line):" > "$CONFIG_FILE"
        echo "# Example: /path/to/file1.txt" >> "$CONFIG_FILE"
        echo "# Example: file2.py" >> "$CONFIG_FILE"
        echo "# Example: ./file3.md" >> "$CONFIG_FILE"
        echo "Config file created. Please add files to watch and run the script again."
        exit 0
    fi

    # Check if the config file is readable
    if [ ! -r "$CONFIG_FILE" ]; then
        echo "Error: Config file '$CONFIG_FILE' is not readable."
        exit 1
    fi

    # Check if entr is installed, and install it if not
    if ! command -v entr &> /dev/null; then
        echo "entr is not installed. Installing..."
        if sudo apt-get update && sudo apt-get install -y entr; then
            echo "entr installed successfully"
        else
            echo "Error installing entr"
            exit 1
        fi
    fi

    # Kill existing entr processes
    pkill entr

    # Start the backup process in the background
    nohup bash -c '
        while true; do
            while IFS= read -r FILE; do
                if [ -n "$FILE" ] && [[ ! "$FILE" =~ ^\s*# ]]; then
                    if [ -f "$FILE" ]; then
                        if [ -r "$FILE" ]; then
                            echo "Watching $FILE"
                            (
                                while true; do
                                    echo "$FILE" | entr -d -c sh -c "cp \"$FILE\" \"$BACKUP_FOLDER/$(basename \"$FILE\").$(date +\"%Y-%m-%d_%H-%M-%S\")\""
                                done
                            ) &
                        else
                            echo "Warning: File \"$FILE\" is not readable. Skipping."
                        fi
                    else
                        echo "Warning: File \"$FILE\" does not exist. Skipping."
                    fi
                fi
            done < "$CONFIG_FILE"
            sleep 60  # Wait for 60 seconds before checking for new files
        done
    ' > /dev/null 2>&1 &

    # Save the PID of the background process
    echo $! > "$PID_FILE"
    echo "Backup process started with PID $(cat "$PID_FILE")"
}

# Function to stop the backup process
stop_backup() {
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if kill -0 $PID 2>/dev/null; then
            kill $PID
            pkill -P $PID
            rm "$PID_FILE"
            echo "Backup process stopped"
        else
            echo "Backup process is not running"
            rm "$PID_FILE"
        fi
    else
        echo "PID file not found. Backup process may not be running."
    fi
}

# Main script logic
case "$1" in
    start)
        start_backup
        ;;
    stop)
        stop_backup
        ;;
    restart)
        stop_backup
        start_backup
        ;;
    *)
        echo "Usage: $0 {start|stop|restart}"
        exit 1
        ;;
esac

exit 0