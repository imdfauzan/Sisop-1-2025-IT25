#!/bin/bash

FILE="reading_data.csv"
if [[ ! -f "$FILE" ]]; then
    echo "File $FILE tidak ditemukan!"
    exit 1
fi

echo "Pilih nomor soal yang ingin dijalankan (a-d) atau (A-D):"
read pilihan

if [[ "$pilihan" == "a" || "$pilihan" == "A" ]]; then
    awk -F ',' '$2 == "Chris Hemsworth" {count++} END {print "Chris Hemsworth membaca", count, "buku."}' "$FILE"

elif [[ "$pilihan" == "b" || "$pilihan" == "B" ]]; then
    awk -F ',' '$8 == "Tablet" {sum+=$6; count++} END {if (count > 0) print "Rata-rata durasi membaca dengan Tablet adalah", sum/cou>
elif [[ "$pilihan" == "c" || "$pilihan" == "C" ]]; then
    awk -F ',' 'NR==1 {next} {if ($7 > max) {max=$7; name=$2; book=$3}} END {print "Pembaca dengan rating tertinggi:", name, "-", bo>
elif [[ "$pilihan" == "d" || "$pilihan" == "D" ]]; then
     awk -F ',' '$9 ~ /Asia/ && $5 > 20231231 {count[$4]++} END {for (g in count) if (count[g] > max) {max = count[g]; genre = g} pr>
    else
    echo "Pilihan tidak valid! Masukkan angka antara a-d atau A-D."
fi
