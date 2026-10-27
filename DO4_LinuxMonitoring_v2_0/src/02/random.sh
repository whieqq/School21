#!/bin/bash


get_random_digit() {
  echo "$((RANDOM % 100 + 1))"
}

get_list_dirs() {
  local count_dirs=$1
  local -a random_dirs
  mapfile random_dirs < <(find / -xdev -type d \( -name bin -o -name sbin \) -prune -o -type d -writable -print 2>/dev/null | shuf -n "$count_dirs")
  printf '%s' "${random_dirs[@]}"
}

