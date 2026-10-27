#!/bin/bash

output() {

  local dir="$(dirname "$0")/nginx_logs"

  check_dir "$dir"

  case "$1" in

    1) output_sort_code $dir;;
    2) output_uniqe_ip $dir;;
    3) output_errors $dir;; # вывести ошибки с кодом 4xx и 5xx
    4) output_uniq_ip_err $dir;; # уникальные ip с кодом ошибки 4xx и 5xx

  esac
}

output_sort_code() {

  local dir=$1
  awk '{ print}' "$dir"/* | sort -k9
}

output_uniqe_ip() {

  local dir=$1
  awk '!seen[$1]++' "$dir"/*

}

output_errors() {

  local dir=$1
  awk '$9 >= 400 && $9 <= 599' "$dir"/*
}

output_uniq_ip_err() {

  local dir=$1

  awk '$9 >= 400 && $9 <= 599 && !seen[$1]++' "$dir"/*
}
