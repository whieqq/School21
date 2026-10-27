#!/bin/bash

make_name_part() {
  local letters=$1
  local index=$2
  local base_len
  local len
  local extra
  local result=""
  local i

  (( base_len = ${#letters} > 4 ? ${#letters} : 4 ))
  (( len = base_len + index ))
  (( extra = len - ${#letters} ))

  for (( i = 0; i < extra; i++ )); do
    result+="${letters:0:1}"
  done

  result+="$letters"
  echo "$result"
}

make_name_dir() {
    local letters=$1
    local index=$2
    local name_part

    name_part=$(make_name_part "$letters" "$index")

    echo "${name_part}_${RUN_DATE}"
}

make_name_file() {
    local letters=$1
    local ext=$2
    local index=$3
    local name_part

    name_part=$(make_name_part "$letters" "$index")

    echo "${name_part}_${RUN_DATE}.${ext}"
}