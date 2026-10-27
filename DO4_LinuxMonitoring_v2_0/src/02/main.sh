#!/bin/bash

start_time=$(date '+%H:%M:%S')
start_ts=$(date +%s)

source "$(dirname "$0")/check_args.sh"
source "$(dirname "$0")/log.sh"
source "$(dirname "$0")/check_disk.sh"
source "$(dirname "$0")/create_files.sh"
source "$(dirname "$0")/make_names.sh"
source "$(dirname "$0")/random.sh"

check_args "$@"

RUN_DATE=$(date +%d%m%y)
LOG_FILE="$(dirname "$0")/file_generator$RUN_DATE.log"

dir_chars_arg=$1
file_chars_arg=$2
file_size_arg=${3^^}

init_log

random_count_dirs=$(get_random_digit)
mapfile -t random_dirs < <(get_list_dirs "$random_count_dirs")
random_count_dirs=${#random_dirs[@]}

echo "The file system clogging has started working."

letters_file=${file_chars_arg%.*}
ext_file=${file_chars_arg#*.}

for (( i = 0; i < "$random_count_dirs"; i++ )); do

  if is_full_disk; then
    echo "Error! Less than 1 GB free space left." >&2
    break
  fi

  dir_name=$(make_name_dir "$dir_chars_arg" "$i")
  new_path_dir="${random_dirs[i]}/$dir_name"
  if ! create_dir "$new_path_dir"; then
    continue
  fi
  stat_date_dir=$(stat -c '%w' "$new_path_dir" | cut -f1 -d' ')
  add_string_log "$new_path_dir" "$stat_date_dir" ""
  random_count_file=$(get_random_digit)
  
  for (( j = 0; j < "$random_count_file"; j++ )); do

    if is_full_disk; then
    echo "Error! Less than 1 GB free space left." >&2
    break 2
    fi

    file_name=$(make_name_file "$letters_file" "$ext_file" "$j")
    new_path_file="$new_path_dir/$file_name"
    if ! create_file "$new_path_file" "$file_size_arg"; then
    continue
    fi
    stat_date_file=$(stat -c '%w' "$new_path_file" | cut -f1 -d' ')
    add_string_log "$new_path_file" "$stat_date_file" "$file_size_arg"
  done

done

end_time=$(date '+%H:%M:%S')
end_ts=$(date +%s)
total_time=$(( end_ts - start_ts ))

print_time "$start_time" "$end_time" "$total_time"


