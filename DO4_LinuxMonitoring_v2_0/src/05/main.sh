#!/bin/bash

source "$(dirname "$0")/check.sh"
source "$(dirname "$0")/output.sh"

check_arg $@
output $1

echo -e "\nDone"