# Anggota Kelompok:
5027241013. Tiara Putri Prasetya
5027241037. Danuja Prasasta Bastu
5027241100. Imam Mahmud Dalil Fauzan

# ========================= SOAL 1 =========================
#membuka dan membuat file baru
nano poppo_siroyo
#!/bin/bash

#izin eksekusi
chmod +x poppo_siroyo.sh

#menjalankan script
./poppo_siroyo.sh

#mengunduh file
wget -O reading data.csv "https://drive.usercontent.google.com/u/0/uc?id=1l8fsj5LZLwXBlHaqhfJVjz_T0p7EJjqV&export=download"

#!/bin/bash

#buat ngecek file ada atau tidak, jika tidak ada akan keluar exit 1
FILE="reading_data.csv"
if [[ ! -f "$FILE" ]]; then
    echo "File $FILE tidak ditemukan!"
    exit 1
fi

#input buat milih nomor soal
echo "Pilih nomor soal yang ingin dijalankan (a-d) atau (A-D):"
read pilihan

#awk buat mencari data
#no.A menghitung jumlah buku yang dibaca chris hemsworth
#$2 karena mencari name di kolom kedua
if [[ "$pilihan" == "a" || "$pilihan" == "A" ]]; then
    awk -F ',' '$2 == "Chris Hemsworth" {count++} END {print "Chris Hemsworth membaca", count, "buku."}' "$FILE"


#no.B menghitung rata2 durasi membaca dengan menggunakan tablet
#$8 karena mencari device yaitu tablet
#sum += $6 untuk menjumlahkan reading duration
#sum/count membagi dan menghitung rata2
elif [[ "$pilihan" == "b" || "$pilihan" == "B" ]]; then
    awk -F ',' '$8 == "Tablet" {sum+=$6; count++} END {if (count > 0) print "Rata-rata durasi membaca dengan Tablet adalah", sum/count, "menit."}' 	reading_data.csv

#no.C mencari pembaca dengan rating yang tertinggi
#NR ==1 {next} melewati baris pertama
#{if....} jika rating lebih besar nilai max sebelumnya maka menyimpan nilai baru
elif [[ "$pilihan" == "c" || "$pilihan" == "C" ]]; then
    awk -F ',' 'NR==1 {next} {if ($7 > max) {max=$7; name=$2; book=$3}} END {print "Pembaca dengan rating tertinggi:", name, "-", book, "-", max}'reading_data.csv


#no.D mencari genre yang paling popular di asia setelah 2023
#$9 mencari region yaitu asia
#$5 mencari read date
#$4 menghitung genre
elif [[ "$pilihan" == "d" || "$pilihan" == "D" ]]; then
     awk -F ',' '$9 ~ /Asia/ && $5 > 20231231 {count[$4]++} END {for (g in count) if (count[g] > max) {max = count[g]; genre = g} print "Genre paling populer di Asia setelah 2023 adalah", genre, "dengan", max, "buku."}' reading_data.csv

#jika memasukkan diluar a-d atau A-D
    else
    echo "Pilihan tidak valid! Masukkan angka antara a-d atau A-D."

# ========================= SOAL 2 =========================

Struktur Soal & Fungsionalitas
1. Authentication System (Register & Login)
File: register.sh, login.sh
Fungsi:
Pemain harus mendaftar sebelum masuk ke sistem.
Password disimpan dalam format SHA-256 dengan static salt untuk keamanan.
Saat login, sistem akan memverifikasi kredensial sebelum memberikan akses ke menu utama.

2. Monitoring System (CPU & RAM)
File:
core_monitor.sh → Pemantauan CPU Usage & CPU Model (Core).
frag_monitor.sh → Pemantauan RAM Usage & Available Memory (Fragments).
Fungsi:
Menggunakan /proc/stat dan /proc/meminfo untuk mengakses resource sistem.
Data yang didapatkan akan dicocokkan dengan tool seperti top/htop agar akurat.

3. Crontab Manager
File: manager.sh
Fungsi:
Menjadwalkan atau menghapus monitoring CPU/RAM menggunakan crontab.
Pemain bisa melihat daftar tugas terjadwal dan menghapusnya jika tidak diperlukan.
Jika belum ada tugas, sistem akan memberi tahu bahwa tidak ada crontab yang berjalan.

4. Logging System
File:
./log/core.log → Log pemantauan CPU
./log/fragment.log → Log pemantauan RAM
Fungsi:
Setiap kali monitoring berjalan, hasilnya akan dicatat dalam format yang terstruktur.
Memudahkan debugging dan pelacakan kinerja sistem dari waktu ke waktu.

5. Terminal Menu (Antarmuka Utama)
File: terminal.sh
Fungsi:
Titik masuk utama bagi pemain untuk mengakses sistem.
Memungkinkan register, login, mengelola crontab, dan logout.
Setelah login, pemain bisa langsung mengakses fitur monitoring.

# ========================= SOAL 3 =========================

Struktur Utama Script
Fungsi-fungsi (Track):
Ada beberapa fungsi yang bisa dijalankan, seperti:

Speak_To_Me: Menampilkan kata-kata motivasi dari API.
On_The_Run: Menampilkan progress bar yang bergerak.
Money: Menampilkan efek visual seperti layar film The Matrix.
Time: Menampilkan waktu, tanggal, dan hari secara real-time.
Brain_Damage: Menampilkan informasi proses sistem secara real-time dengan warna-warni.
Argumen Input: Script ini menerima argumen dari pengguna dengan format --play="<Track>".
Contoh: ./<file>.sh --play="Speak To Me".

Penjelasan Fungsi-fungsi:

1. Speak_To_Me
Menampilkan kata-kata motivasi (affirmations) dari sebuah API secara terus-menerus.
Cara kerja:
Menggunakan curl untuk mengambil data dari https://www.affirmations.dev.
Menggunakan jq untuk mengambil teks affirmations dari respons JSON.
Jika gagal mengambil data, akan mencoba lagi.
Menampilkan satu affirmation setiap 1 detik.

2. On_The_Run
Menampilkan progress bar yang bergerak dari 0% sampai 100%.
Cara kerja:
Menggunakan loop untuk mengupdate progress bar.
Setiap langkah progress bar memiliki delay acak antara 0.1 sampai 1 detik.
Progress bar ditampilkan dengan karakter # yang semakin banyak seiring progress.

3. Money
Menampilkan efek visual seperti layar film The Matrix dengan karakter-karakter Jepang dan warna-warni.
Cara kerja:
Menggunakan array karakter Jepang (ｱ ｲ ｳ ｴ ｵ ...) dan array warna.
Karakter dan warna dipilih secara acak.
Efek ini terus berjalan sampai pengguna menekan Ctrl+C untuk menghentikannya.

4. Time
Menampilkan waktu, tanggal, dan hari secara real-time.
Cara kerja:
Menggunakan perintah date untuk mengambil informasi waktu, tanggal, dan hari.
Layar di-update setiap 1 detik.

5. Brain_Damage
Menampilkan informasi proses sistem (seperti top) secara real-time dengan warna-warni.
Cara kerja:
Menggunakan perintah top untuk mengambil informasi proses.
Setiap baris output diwarnai dengan warna yang berbeda.
Layar di-update setiap 1 detik.

6. show_help
Menampilkan petunjuk penggunaan script.
Cara kerja:
Menjelaskan cara menjalankan script dan daftar track yang tersedia.

7. Logika Utama
Mengecek argumen yang diberikan pengguna.
Menjalankan fungsi sesuai dengan track yang dipilih.
Cara kerja:
Menggunakan if-elif-else untuk membandingkan argumen yang diberikan.
Jika argumen valid, fungsi yang sesuai akan dijalankan.
Jika argumen tidak valid, akan menampilkan pesan error dan petunjuk penggunaan.
Cara Menjalankan Script
Berikan izin eksekusi dengan perintah: chmod +x <file>.sh
Jalankan script dengan perintah: ./<file>.sh --play="<Track>"
Ganti <Track> dengan nama track yang ingin dijalankan, misalnya:

Speak To Me
On The Run
Money
Time
Brain Damage

Contoh Penggunaan
Menjalankan track Speak To Me: ./<file>.sh --play="Speak To Me"
Menjalankan track Time: ./<file>.sh --play="Time"

# ========================= SOAL 4 =========================

1. Script ini berfungsi untuk:
- Melihat ringkasan data
- Mengurutkan berdasarkan berbagai parameter
- Mencari Pokémon berdasarkan nama
- Menyaring Pokémon berdasarkan tipe
- Menampilkan pesan bantuan interaktif

2. File-File yang Digunakan
pokemon_analysis.sh → Skrip utama yang mengolah data
pokemon_usage.csv → Dataset Pokémon dalam format CSV yang berisi statistik penggunaan
Tambahan (jika ada) → File atau aset lain seperti ASCII art untuk tampilan

3. Fungsi-Fungsi dalam Script
Berikut adalah beberapa fungsi utama dalam script:

usagetertinggi() → Menampilkan Pokémon dengan Usage% tertinggi
rawusagetertinggi() → Menampilkan Pokémon dengan Raw Usage tertinggi
sort_data(column) → Mengurutkan data berdasarkan kolom tertentu
matched(name) → Mencari Pokémon berdasarkan nama tertentu
filter_type(type) → Menyaring Pokémon berdasarkan jenis (type)
display_help() → Menampilkan pesan bantuan dengan ASCII art

4. Cara Kerja Script
  A. Mengecek Jumlah Argumen, Jika argumen tidak cukup, menampilkan error message
  B. Membaca Dataset (pokemon_usage.csv), Menggunakan awk atau grep untuk membaca dan memfilter data
  C. Memproses Perintah dari Pengguna
      --info → Menampilkan ringkasan
      --sort <column> → Mengurutkan data berdasarkan kolom yang dipilih
      --grep <name> → Mencari Pokémon berdasarkan nama
      --filter <type> → Menampilkan Pokémon dengan tipe tertentu
      --help atau -h → Menampilkan pesan bantuan
  D. Menampilkan Hasil dengan Format CSV
