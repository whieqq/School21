#!/bin/bash

# функция для проверки введенных параметров
check_args() {

  if [[ $# -ne 3 ]]; then
    echo "Error! You need to enter 3 parameters"
    echo "Example: main.sh az az.az 3Mb"
    exit 1
  fi

  if ! [[ $1 =~ ^[a-zA-Z]{1,7}$ ]]; then
    echo "Error! Invalid parameter - '$1'."
    echo "You need to enter characters of the English alphabet. but no more than 7"
    exit 4
  fi

  if ! [[ $2 =~ ^[a-zA-Z]{1,7}\.[a-zA-Z]{1,3}$ ]]; then
    echo "Error! Invalid parameter - '$2'."
    echo "You need to enter characters of the English alphabet:"
    echo "- no more than 7 for the filename;"
    echo "- no more than 3 for the file extension."
    exit 6
  fi

  if ! { [[ $3 =~ ^([1-9][0-9]{0,2})[mM][bB]$ ]] && 
       (( BASH_REMATCH[1] >= 1 && BASH_REMATCH[1] <= 100 ))
       }; then 
    echo "Error! Invalid parameter - '$3'."
    echo "You need to enter the file size in megabytes, but no more than 100."
    exit 7
  fi
} >&2

