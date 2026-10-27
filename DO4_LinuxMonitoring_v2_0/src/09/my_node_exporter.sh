#!/bin/bash

# Экспортёр метрик в формате Prometheus.
# Пишет текстовый файл, который раздаёт nginx.

OUT="/var/www/html/metrics"
INTERVAL=3

# total и idle тиков из /proc/stat
read_cpu() {
    awk '/^cpu /{
            idle = $5 + $6
            total = 0
            for (i = 2; i <= NF; i++) total += $i
            print total, idle
         }' /proc/stat
}

read prev_total prev_idle < <(read_cpu)

while true; do
    sleep "$INTERVAL"

    read cur_total cur_idle < <(read_cpu)
    d_total=$(( cur_total - prev_total ))
    d_idle=$(( cur_idle  - prev_idle  ))
    prev_total=$cur_total
    prev_idle=$cur_idle

    cpu_busy=$(awk -v t="$d_total" -v i="$d_idle" \
        'BEGIN { if (t > 0) printf "%.2f", (1 - i / t) * 100; else printf "0.00" }')

    mem_total=$(awk '/^MemTotal:/     { print $2 * 1024 }' /proc/meminfo)
    mem_avail=$(awk '/^MemAvailable:/ { print $2 * 1024 }' /proc/meminfo)

    read fs_size fs_avail < <(df -B1 --output=size,avail / | tail -1)

    tmp="${OUT}.tmp.$$"
    {
        echo "# HELP my_cpu_usage_percent Загрузка процессора в процентах."
        echo "# TYPE my_cpu_usage_percent gauge"
        echo "my_cpu_usage_percent ${cpu_busy}"
        echo "# HELP my_memory_total_bytes Всего оперативной памяти, байт."
        echo "# TYPE my_memory_total_bytes gauge"
        echo "my_memory_total_bytes ${mem_total}"
        echo "# HELP my_memory_available_bytes Доступно оперативной памяти, байт."
        echo "# TYPE my_memory_available_bytes gauge"
        echo "my_memory_available_bytes ${mem_avail}"
        echo "# HELP my_filesystem_size_bytes Размер корневой файловой системы, байт."
        echo "# TYPE my_filesystem_size_bytes gauge"
        echo "my_filesystem_size_bytes{mountpoint=\"/\"} ${fs_size}"
        echo "# HELP my_filesystem_avail_bytes Свободно на корневой файловой системе, байт."
        echo "# TYPE my_filesystem_avail_bytes gauge"
        echo "my_filesystem_avail_bytes{mountpoint=\"/\"} ${fs_avail}"
    } > "$tmp"
    mv -f "$tmp" "$OUT"
done
