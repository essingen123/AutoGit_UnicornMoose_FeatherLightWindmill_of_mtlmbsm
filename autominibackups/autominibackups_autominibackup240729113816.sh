#!/bin/bash

CONFIG_FILE="autominibackups_file_watch_config.txt"
BACKUP_FOLDER="autominibackups"
QUIET_MODE=false
BACKGROUND_MODE=false

# Create the config file if it doesn't exist
if [ ! -f "$CONFIG_FILE" ]; then
  echo "# Enter files to watch (one per line):" > "$CONFIG_FILE"
  echo "# Example: ./file.txt" >> "$CONFIG_FILE"
  echo "# Example: file.txt" >> "$CONFIG_FILE"
  echo "# Example: ~/Desktop/file1.txt" >> "$CONFIG_FILE"
  echo "quiet_mode: false" >> "$CONFIG_FILE"
  echo "background_mode: false" >> "$CONFIG_FILE"
  echo "Config file created. Please add files to watch in $CONFIG_FILE and run the script again."
  exit 0
fi

# Read backup folder path from config file
if grep -q "^backup_folder: " "$CONFIG_FILE"; then
  BACKUP_FOLDER=$(grep -oP '(?<=^backup_folder: ).*' "$CONFIG_FILE")
fi

# Create the backup folder if it doesn't exist
mkdir -p "$BACKUP_FOLDER"

# Check if entr is installed, and install it if not
if ! type -p entr &> /dev/null; then
  echo "entr is not installed. Installing..."
  sudo apt-get update && sudo apt-get install -y entr
  if [ $? -ne 0 ]; then
    echo "Error installing entr. Please install it manually."
    exit 1
  fi
fi

# Read quiet mode from config file
if grep -q "^quiet_mode: true" "$CONFIG_FILE"; then
  QUIET_MODE=true
fi

# Read background mode from config file
if grep -q "^background_mode: true" "$CONFIG_FILE"; then
  BACKGROUND_MODE=true
fi

# Function to check if a file is readable
is_file_readable() {
  local file="$1"
  if [ ! -f "$file" ]; then
    echo "Warning: File '$file' does not exist. Skipping."
    return 1
  elif [ ! -r "$file" ]; then
    echo "Warning: File '$file' is not readable. Skipping."
    return 1
  fi
  return 0
}

# Function to watch a file
watch_file() {
  local file="$1"
  if is_file_readable "$file"; then
    echo "Watching $file"
    (
      while true; do
        filename="${file##*/}"
        extension="${filename##*.}"
        filename_no_ext="${filename%.*}"
        timestamp=$(date +'%y%m%d%H%M%S')
        backup_filename="${filename_no_ext}_autominibackup${timestamp}.${extension}"
        if [ "$QUIET_MODE" = false ]; then
          echo "Saving $file to $BACKUP_FOLDER/$backup_filename"
        fi
        cp "$file" "$BACKUP_FOLDER/$backup_filename"
        sleep 1
      done
    ) &
  fi
}

# Read the config file and start watching files with entr
while IFS= read -r file; do
  if [ -n "$file" ] && [[ ! "$file" =~ ^\s*# ]]; then
    watch_file "$file"
  fi
done < "$CONFIG_FILE"

if [ "$BACKGROUND_MODE" = true ]; then
  echo "Running in background mode. Use 'pkill entr' to stop."
else
  echo "File watching started. Press Ctrl+C to stop."
  wait
fi
