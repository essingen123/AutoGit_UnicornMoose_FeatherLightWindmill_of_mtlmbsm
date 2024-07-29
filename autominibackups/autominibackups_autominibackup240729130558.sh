#!/bin/bash
# filename (or originally): kilian_air_lightweight_auto_file_watch_minibackup.py + kilian_air_lightweight_auto_file_watch_minibackup.py 
# very simple intentionally 

BACKUP_FOLDER="autominibackups"
CONFIG_FILE="autominibackups_file_watch_config.txt"

mkdir -p "$BACKUP_FOLDER"

if [ ! -f "$CONFIG_FILE" ]; then
echo "# Enter files to watch (one per line):" > "$CONFIG_FILE"
echo "# Example: /path/to/file1.txt" >> "$CONFIG_FILE"
echo "Config file created. Please add files to watch in $CONFIG_FILE and run the script again."
exit 0
fi

if ! command -v entr &> /dev/null; then
echo "entr is not installed. Please install it and run the script again."
exit 1
fi

is_file_readable() {
local file="$1"
if [ ! -f "$file" ]; then
    return 1
fi
if [ ! -r "$file" ]; then
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
