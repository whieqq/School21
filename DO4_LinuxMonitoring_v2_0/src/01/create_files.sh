#!/bin/bash

create_file() {
  local path_file=$1
  local size_file=$2

  if is_full_disk; then
    echo "Error! Less than 1 GB free space left." >&2
    exit 7
  else
    if ! fallocate -l "$size_file" "$path_file" 2>/dev/null; then
    dd if=/dev/zero of="$path_file" bs="$size_file" count=1 status=none
    fi
  fi
}

create_dir() {
  local path_dir=$1

  if ! mkdir -p "$path_dir"; then
    echo "Error! Failed to create the directory." >&2
    exit 8
  fi
}