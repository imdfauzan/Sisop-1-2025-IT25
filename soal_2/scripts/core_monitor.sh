#!/bin/bash

# cek apkah script ini dijalankan dgn izin yg cukup, EUID = effective user id
if [ "$EUID" -ne 0 ]; then
    echo "Jalankan script ini pakai sudo!"
    exit 1
fi

# buat file log
LOG_FILE="./log/core.log"

# fungsi print cpu
CPU_USAGE=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage "%"}')
CPU_MODEL=$(grep -m 1 "model name" /proc/cpuinfo | awk -F: '{print $2}')

TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
echo "[$TIMESTAMP] - Core Usage [$CPU_USAGE%] - Model CPU:[$CPU_MODEL]" >> "$LOG_FILE"

echo "CPU Usage: $CPU_USAGE"
echo "CPU Model: $CPU_MODEL"
