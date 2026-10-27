#!/bin/bash

declare -a STATUS=(200 201 400 401 403 404 500 501 502 503)
declare -a METHODS=("GET" "POST" "PUT" "PATCH" "DELETE")
declare -a AGENTS=("Mozilla" "Google Chrome" "Opera" "Safari" "Internet Explorer" "Microsoft Edge" "Crawler and bot" "Library and net tool")

generate() {

  local filename=$1
  local count_day=$2

  count_string=$(get_random_digit 901 100)

  identd="-"
  remote_user="-"
  http_referer="-"
  for (( j=1; j<=count_string; j++ )); do

    remote_addr=$(get_random_ip)
    time_local=$(LC_ALL=C date -d "+$count_day day" '+%d/%b/%Y:%H:%M:%S %z')

    method=$(get_random_item METHODS)
    url="/page_$(get_random_digit 1001 1)"
    request="$method $url HTTP/1.1"

    status=$(get_random_item STATUS)

    bytes_sent=$(get_random_digit  10000 100)

    http_user_agent=$(get_random_item AGENTS)


    # COMBINED: remote_addr identd remote_user [time_local] "request" status bytes_sent "http_referer" "http_user_agent"
    echo "$remote_addr $identd $remote_user [$time_local] \"$request\" $status $bytes_sent \"$http_referer\" \"$http_user_agent\"" >> $filename
done
}