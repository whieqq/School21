#!/bin/bash

is_full_disk() {
  local limit=$(( 1000 * 1000 * 1000 ))
  local avail

  avail=$(df --output=avail -B1 / | tail -n1)
  
  (( avail <= limit ))
}