#!/bin/bash

LOG_FILE="../log/fragment.log"

# ambil datanya dan dibagi 1024 (mengubah satuan dari KB ke MB)
RAM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
RAM_AVAILABLE=$(free -m | awk '/Mem:/ {print $7}')
RAM_USED=$(echo "$RAM_TOTAL - $RAM_AVAILABLE" | bc)
RAM_USAGE=$(echo "scale=2; $RAM_USED/$RAM_TOTAL*100" | bc)


TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
echo "[$TIMESTAMP] - Fragment Usage [$RAM_USAGE%] - Fragment Count [$RAM_USED MB] - Details [Total: $RAM_TOTAL MB, Available: $RAM_AVAILABLE MB]" >> "$LOG_FILE"

echo "Total RAM: $RAM_TOTAL"
echo "Available RAM: $RAM_AVAILABLE"
echo "RAM Usage: $RAM_USAGE%"
