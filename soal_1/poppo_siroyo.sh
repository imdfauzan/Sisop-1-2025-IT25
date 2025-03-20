#membuka dan membuat file baru nano poppo_siroyo #!/bin/bash

#izin eksekusi chmod +x poppo_siroyo.sh

#menjalankan script ./poppo_siroyo.sh

#mengunduh file wget -O reading data.csv "https://drive.usercontent.google.com/u/0/uc?id=1l8fsj5LZLwXBlHaqhfJVjz_T0p7EJjqV&export=download"

#!/bin/bash

#buat ngecek file ada atau tidak, jika tidak ada akan keluar exit 1 FILE="reading_data.csv" if [[ ! -f "$FILE" ]]; then echo "File $FILE tidak ditemukan!" exit 1 fi

#input buat milih nomor soal echo "Pilih nomor soal yang ingin dijalankan (a-d) atau (A-D):" read pilihan

#awk buat mencari data #no.A menghitung jumlah buku yang dibaca chris hemsworth #$2 karena mencari name di kolom kedua if [[ "$pilihan" == "a" || "$pilihan" == "A" ]]; then awk -F ',' '$2 == "Chris Hemsworth" {count++} END {print "Chris Hemsworth membaca", count, "buku."}' reading_data.csv

#no.B menghitung rata2 durasi membaca dengan menggunakan tablet #$8 karena mencari device yaitu tablet #sum += $6 untuk menjumlahkan reading duration #sum/count membagi dan menghitung rata2 elif [[ "$pilihan" == "b" || "$pilihan" == "B" ]]; then awk -F ',' '$8 == "Tablet" {sum+=$6; count++} END {if (count > 0) print "Rata-rata durasi membaca dengan Tablet adalah", sum/count, "menit."}' reading_data.csv

#no.C mencari pembaca dengan rating yang tertinggi #NR ==1 {next} melewati baris pertama #{if....} jika rating lebih besar nilai max sebelumnya maka menyimpan nilai baru elif [[ "$pilihan" == "c" || "$pilihan" == "C" ]]; then awk -F ',' 'NR==1 {next} {if ($7 > max) {max=$7; name=$2; book=$3}} END {print "Pembaca dengan rating tertinggi:", name, "-", book, "-", max}' reading_data.csv

#no.D mencari genre yang paling popular di asia setelah 2023 #$9 mencari region yaitu asia #$5 mencari read date #$4 menghitung genre elif [[ "$pilihan" == "d" || "$pilihan" == "D" ]]; then awk -F ',' '$9 ~ /Asia/ && $5 > 20231231 {count[$4]++} END {for (g in count) if (count[g] > max) {max = count[g]; genre = g} print "Genre paling populer di Asia setelah 2023 adalah", genre, "dengan", max, "buku."}' reading_data.csv

#jika memasukkan diluar a-d atau A-D else echo "Pilihan tidak valid! Masukkan angka antara a-d atau A-D."
