#!/bin/bash

get_random_digit() {
  echo "$((RANDOM % $1 + $2))"
}

get_random_ip() {

  local i

  local -a octet

  for i in 0 1 2 3; do
    octet["$i"]=$(get_random_digit 254 1)
  done

  echo "${octet[0]}.${octet[1]}.${octet[2]}.${octet[3]}"
}

get_random_item() {
  local -n arr=$1
  echo "${arr[RANDOM % ${#arr[@]}]}"
}
