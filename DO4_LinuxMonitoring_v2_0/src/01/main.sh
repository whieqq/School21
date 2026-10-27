#!/bin/bash

source "$(dirname "$0")/check_args.sh"
source "$(dirname "$0")/create_log.sh"
source "$(dirname "$0")/check_disk.sh"
source "$(dirname "$0")/create_files.sh"
source "$(dirname "$0")/make_names.sh"

check_args "$@"

RUN_DATE=$(date +%d%m%y)
LOG_FILE="$(dirname "$0")/file_generator$RUN_DATE.log"

base_path_arg="${1%/}"
dir_counts_arg=$2
dir_chars_arg=$3
file_counts_arg=$4
file_chars_arg=$5
file_size_arg=${6^^}

init_log

echo "The file generator has started working."

letters_file=${file_chars_arg%.*}
ext_file=${file_chars_arg#*.}

for (( i = 0; i < "$dir_counts_arg"; i++ )); do
  if is_full_disk; then
    echo "Error! Less than 1 GB free space left." >&2
    break
  fi
  dir_name=$(make_name_dir "$dir_chars_arg" "$i")
  new_path_dir="$base_path_arg/$dir_name"
  create_dir "$new_path_dir"
  stat_date_dir=$(stat -c '%w' "$new_path_dir" | cut -f1 -d' ')
  add_string_log "$new_path_dir" "$stat_date_dir" ""
  for (( j = 0; j < "$file_counts_arg"; j++ )); do
    if is_full_disk; then
    echo "Error! Less than 1 GB free space left." >&2
    break 2
    fi
    file_name=$(make_name_file "$letters_file" "$ext_file" "$j")
    new_path_file="$new_path_dir/$file_name"
    create_file "$new_path_file" "$file_size_arg"
    stat_date_file=$(stat -c '%w' "$new_path_file" | cut -f1 -d' ')
    add_string_log "$new_path_file" "$stat_date_file" "$file_size_arg"
  done
  base_path_arg="$new_path_dir"
done

echo "Done"




