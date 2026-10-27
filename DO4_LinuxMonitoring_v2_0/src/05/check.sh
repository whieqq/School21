#!/bin/bash

check_arg() {

  if [[ $# -ne 1 ]]; then
    echo "Error! You need to enter one argument"
    exit 1
  elif ! [[ $1 =~ ^[1-4]$ ]]; then
    echo "Error! You need to enter a number from 1 to 4."
    exit 2
  fi
} >&2

check_dir() {

  local path=$1
  
  if ! [[ -d "$path" ]]; then
    echo "Error! The dir '$path' does not exist"
    exit 3
  fi

} >&2
