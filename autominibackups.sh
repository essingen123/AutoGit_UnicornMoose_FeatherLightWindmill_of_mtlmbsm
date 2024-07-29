#!/bin/bash

BACKUP_FOLDER="autominibackups"
CONFIG_FILE="autominibackups_file_watch_config.txt"

mkdir -p "$BACKUP_FOLDER"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "# Enter files to watch (one per line):" > "$CONFIG_FILE"
  echo "# Example: /path/to/file1.txt" >> "$CONFIG_FILE"
  for file in *; do
    if [ -f "$file" ]; then
      echo "$PWD/$file" >> "$CONFIG_FILE"
    fi
  done
fi

if ! command -v entr &> /dev/null; then
  echo "entr is not installed. Please install it and run the script again."
  exit 1
fi

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

watch_file() {
  local file="$1"
  if is_file_readable "$file"; then
    echo "Watching $file"
    filename="${file##*/}"
    extension="${filename##*.}"
    filename_no_ext="${filename%.*}"
    timestamp=$(date +'%y%m%d%H%M%S')
    backup_filename="${filename_no_ext}_autominibackup${timestamp}.${extension}"
    echo "$file" | entr -p sh -c "cp '$file' '$BACKUP_FOLDER/$backup_filename'" &
  fi
}

while IFS= read -r file; do
  if [ -n "$file" ] && [[ ! "$file" =~ ^\s*# ]]; then
    watch_file "$file"
  fi
done < "$CONFIG_FILE"

echo "File watching started. Press Ctrl+C to stop."
wait

