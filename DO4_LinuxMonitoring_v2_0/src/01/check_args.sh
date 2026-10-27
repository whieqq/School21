#!/bin/bash

# функция для проверки введенных параметров
check_args() {

  if [[ $# -ne 6 ]]; then
    echo "Error! You need to enter 6 parameters"
    echo "Example: main.sh /home/whie/test 4 az 5 az.az 3kb"
    exit 1
  fi

  if [[  "${1:0:1}" != "/" || ! -d "$1" ]]; then
    echo "Error! Invalid parameter - '$1'."
    echo "The path is not absolute or it does not exist!"
    exit 2
  fi

  if ! [[ $2 =~ ^[1-9][0-9]*$ ]]; then
    echo "Error! Invalid parameter - '$2'."
    echo "You need to enter digit"
    exit 3
  fi

  if ! [[ $3 =~ ^[a-zA-Z]{1,7}$ ]]; then
    echo "Error! Invalid parameter - '$3'."
    echo "You need to enter characters of the English alphabet. but no more than 7"
    exit 4
  fi

  if ! [[ $4 =~ ^[1-9][0-9]*$ ]]; then
    echo "Error! Invalid parameter - '$4'."
    echo "You need to enter digit"
    exit 5
  fi

  if ! [[ $5 =~ ^[a-zA-Z]{1,7}\.[a-zA-Z]{1,3}$ ]]; then
    echo "Error! Invalid parameter - '$5'."
    echo "You need to enter characters of the English alphabet:"
    echo "- no more than 7 for the filename;"
    echo "- no more than 3 for the file extension."
    exit 6
  fi

  if ! { [[ $6 =~ ^([1-9][0-9]{0,2})[kK][bB]$ ]] && 
       (( BASH_REMATCH[1] >= 1 && BASH_REMATCH[1] <= 100 ))
       }; then 
    echo "Error! Invalid parameter - '$6'."
    echo "You need to enter the file size in kilobytes, but no more than 100."
    exit 7
  fi
} >&2

