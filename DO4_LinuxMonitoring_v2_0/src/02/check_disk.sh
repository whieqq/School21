#!/bin/bash

is_full_disk() {
  local limit=$(( 1000 * 1000 * 1000 ))
  local avail
  local bytes

  avail=$(df -h / | awk 'NR==2 {print $4}')
  bytes=$(numfmt --from=iec "$avail")

  (( bytes <= limit ))
}