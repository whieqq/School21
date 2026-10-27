#!/bin/bash

# функции для проверки введенных параметров

check_args() {

  if (( $# != 1 )); then
    echo "Error! The script takes exactly one parameter."
    print_help
    exit 2
  fi

  if ! [[ $1 =~ ^[1-3]$ ]]; then
    echo "Error! Invalid parameter - '$1'."
    echo "You need to enter a number from 1 to 3"
    print_help
    exit 1
  fi
} >&2

check_args_del_log() {

  if ! [[ -f "$1" ]]; then
    echo "The file '$1' does not exist"
    exit 3
  fi
} >&2

check_iso_date() {

  local iso_date=$1

  if ! date -d "$iso_date" >/dev/null 2>&1; then
    echo "Error! Incorrect date or time - '$iso_date'." >&2
    exit 5
  fi
}

check_date_time() {

  local ch_date=$1
  local ch_time=$2
  local iso_date

  if [[ "$ch_date $ch_time" =~ ^([0-9]{2})-([0-9]{2})-([0-9]{4})\ ([0-9]{2}):([0-9]{2})$ ]]; then
    iso_date="${BASH_REMATCH[3]}-${BASH_REMATCH[2]}-${BASH_REMATCH[1]} ${BASH_REMATCH[4]}:${BASH_REMATCH[5]}"
    check_iso_date "$iso_date"
  else
    echo "Error! Invalid date and time format - '$ch_date $ch_time'." >&2
    exit 6
  fi
}

check_args_del_mask() {

  local iso_date

  if ! [[ "$1" =~ ^[0-9]{6}$ ]]; then
    echo "Error! Invalid format - '$1'." >&2
    exit 7
  fi
  iso_date="20${1:4:2}-${1:2:2}-${1:0:2}"
  check_iso_date "$iso_date"
}