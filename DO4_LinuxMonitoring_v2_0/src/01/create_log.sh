#!/bin/bash

init_log() {
  if ! : > "$LOG_FILE"; then
    echo "Error! Failed to create the log file." >&2
    exit 9
  fi
}

add_string_log() {
  local path="$1"
  local create_date="$2"
  local file_size="$3"

  if [[ -z "$file_size" ]]; then
    file_size="-"
  fi

  printf '%s|%s|%s\n' "$path" "$create_date" "$file_size" >> "$LOG_FILE"
}