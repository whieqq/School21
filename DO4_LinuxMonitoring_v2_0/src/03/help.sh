#!/bin/bash

print_help() {
  echo
  echo "Deletion based on log file"
  echo "Example: ./main.sh 1"
  echo
  echo "Deletion by creation date and time"
  echo "Example: ./main.sh 2"
  echo
  echo "Deletion based on file mask"
  echo "Example: ./main.sh 3"
} >&2