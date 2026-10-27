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

print_separators() {
	printf '=%.s' {1..50} 
	printf '\n'
} >> "$LOG_FILE"

print_time() {
  local start_time=$1
  local end_time=$2
  local total_time=$3

  print_separators
  echo "Start time: $start_time" >> "$LOG_FILE"
	echo "End time: $end_time" >> "$LOG_FILE"
	echo "Total time: $total_time sec" >> "$LOG_FILE"

  echo "Done"
	echo "Start time: $start_time"
	echo "End time: $end_time"
	echo "Total time: $total_time sec"
}