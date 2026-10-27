#!/bin/bash

del_files_log() {

  local file_log
  local path

  read -rp "Enter the path to the log file: " file_log

  check_args_del_log "$file_log"

  while IFS='|' read -r path _; do
    [[ $path == /* ]] || continue
    rm -rf "$path"
  done < "$file_log"

  echo "Done"
}

del_files_date() {

  local start_date
  local start_time
  local end_date
  local end_time

  local start_ts
  local end_ts

  local path
  local file_ts

  read -rp "Enter start date (DD-MM-YYYY): " start_date
  read -rp "Enter start time (HH:MM): "     start_time
  read -rp "Enter end date (DD-MM-YYYY): "  end_date
  read -rp "Enter end time (HH:MM): "       end_time

  check_date_time "$start_date" "$start_time"
  check_date_time "$end_date" "$end_time"

  start_date="${start_date:6:4}-${start_date:3:2}-${start_date:0:2}"
  end_date="${end_date:6:4}-${end_date:3:2}-${end_date:0:2}"

  start_ts=$(date -d "$start_date $start_time" +%s)
  end_ts=$(( $(date -d "$end_date $end_time" +%s) + 59))
 

  if (( start_ts > end_ts )); then
		echo "Error! Start date is after end date" >&2
		exit 9
  fi

  find / -xdev -type d \( -name bin -o -name sbin \) -prune -o -print0 2>/dev/null \
  | xargs -0 stat -c '%W|%n' 2>/dev/null \
  | while IFS='|' read -r file_ts path; do
      (( file_ts >= start_ts && file_ts <= end_ts )) && rm -rf "$path"
    done


  echo "Done"
}

del_files_mask() {

  local mask

  read -rp "Enter date (DDMMYY): " mask

  check_args_del_mask "$mask"

  find / -xdev -type d \( -name bin -o -name sbin \) -prune \
       -o -regextype posix-extended \
       -regex ".*/[a-zA-Z]+_${mask}(\.[a-zA-Z]{1,3})?" -print0 2>/dev/null \
  | xargs -0 -r rm -rf


  echo "Done"
}