#!/bin/bash

start_script_time=$(date +%s.%N)

if [[ $# -eq 0 ]]; then
  echo "Ошибка! Параметр не введен" >&2
  exit 1
elif [[ $# -gt 1 ]]; then
  echo "Ошибка! Введено более одного параметра" >&2
  exit 2
fi

MY_PATH="$1"

if ! [[ "$MY_PATH" =~ /$ ]]; then
  echo "Ошибка! Путь не валидный. На конце должен быть /" >&2
  exit 3
elif ! [[ -d "$MY_PATH" ]]; then
  echo "Ошибка! Каталог не существует" >&2
  exit 4
fi


total_dir=$(find "$MY_PATH" -mindepth 1 -type d 2>/dev/null | wc -l)
top_5_dir=$(find "$MY_PATH" -mindepth 1 -type d -exec du -sb {} + 2>/dev/null | sort -rn | head -5 | awk '
          function human(x) {
            if (x < 1000) return sprintf("%.0f B", x)
            x /= 1000
            if (x < 1000) return sprintf("%.0f KB", x)
            x /= 1000
            if (x < 1000) return sprintf("%.0f MB", x)
            x /= 1000
            return sprintf("%.0f GB", x)
          }
          { print NR, "-", $2, human($1) }')
total_files=$(find "$MY_PATH" -mindepth 1 -type f 2>/dev/null | wc -l)
count_conf_files=$(find "$MY_PATH" -type f -name "*.conf" 2>/dev/null | wc -l)
count_text_files=$(find "$MY_PATH" -type f -exec file --mime-type {} + 2>/dev/null | grep -c ':[[:space:]]*text/')
count_exec_files=$(find "$MY_PATH" -type f -executable 2>/dev/null | wc -l)
count_log_files=$(find "$MY_PATH" -type f -name "*.log" 2>/dev/null | wc -l)
count_archive_files=$(find "$MY_PATH" -type f -exec file --mime-type {} + 2>/dev/null | grep -c -E 'application/(zip|gzip|x-tar|x-xz|x-bzip2|x-rar|x-7z-compressed)')
count_symlink_files=$(find "$MY_PATH" -type l 2>/dev/null | wc -l)
top_10_files=$(find "$MY_PATH" -mindepth 1 -type f -printf "%s\t%p\n" 2>/dev/null | sort -rn -t $'\t' -k1,1 | head -10 | awk -F'\t' '
          function human(x) {
            if (x < 1000) return sprintf("%.0f B", x)
            x /= 1000
            if (x < 1000) return sprintf("%.0f KB", x)
            x /= 1000
            if (x < 1000) return sprintf("%.0f MB", x)
            x /= 1000
            return sprintf("%.0f GB", x)
          }
          function get_ext(f) {
            if (f ~ /\.[^/]+$/) {
              sub(/^.*\./, "", f)
              return f
            }
            return "unknown"
          }
          { print NR, "-", $2, human($1), get_ext($2) }')
top_10_exec=$(find "$MY_PATH" -mindepth 1 -type f -executable -printf "%s\t%p\n" 2>/dev/null | sort -rn -t $'\t' -k1,1 | head -10 |
    while IFS=$'\t' read -r size path; do
        md5=$(md5sum "$path" 2>/dev/null | awk '{print $1}')
        printf "%s\t%s\t%s\n" "$path" "$size" "$md5"
    done | awk -F'\t' '
           function human(x) {
             if (x < 1000) return sprintf("%.0f B", x)
             x /= 1000
             if (x < 1000) return sprintf("%.0f KB", x)
             x /= 1000
             if (x < 1000) return sprintf("%.0f MB", x)
             x /= 1000
             return sprintf("%.0f GB", x)
            }
            { print NR, "-", $1, human($2), $3 }')

printf '%s\n' "Total number of folders (including all nested ones) = $total_dir"
echo "TOP 5 folders of maximum size arranged in descending order (path and size):"
printf '%s\n' "$top_5_dir"
printf '%s\n' "Total number of files = $total_files"
echo "Number of:"
printf '%s\n' "Configuration files (with the .conf extension) = $count_conf_files"
printf '%s\n' "Text files = $count_text_files"
printf '%s\n' "Executable files = $count_exec_files"
printf '%s\n' "Log files (with the extension .log) = $count_log_files"
printf '%s\n' "Archive files = $count_archive_files"
printf '%s\n' "Symbolic links = $count_symlink_files"
echo "TOP 10 files of maximum size arranged in descending order (path, size and type):"
printf '%s\n' "$top_10_files"
echo "TOP 10 executable files of the maximum size arranged in descending order (path, size and MD5 hash of file):"
printf '%s\n' "$top_10_exec"


end_script_time=$(date +%s.%N)
script_exec_time=$(echo "$end_script_time - $start_script_time" | bc)
formatted_time=$(echo "$script_exec_time" | awk '{printf "%.1f", $1}')
printf '%s\n' "Script execution time (in seconds) = $formatted_time"