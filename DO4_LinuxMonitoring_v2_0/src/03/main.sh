#!/bin/bash

source "$(dirname "$0")/help.sh"
source "$(dirname "$0")/check.sh"
source "$(dirname "$0")/del.sh"


check_args "$@"

case "$1" in
1)  del_files_log;;
2)  del_files_date;;
3)  del_files_mask;;
esac


