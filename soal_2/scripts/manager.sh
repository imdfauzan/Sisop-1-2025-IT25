#!/bin/bash

CPU_SCRIPT="$HOME/soal_2/scripts/core_monitor.sh"
RAM_SCRIPT="$HOME/soal_2/scripts/frag_monitor.sh"

# ngecek apkah core_monitor.sh dan frag_monitor.sh ada
if [ ! -f "$CPU_SCRIPT" ] || [ ! -f "$RAM_SCRIPT" ]; then
    echo "Error: Script pemantauan tidak ditemukan!"
    exit 1
fi

# fungsi u. mengecek apakah ada crontab yg sdg berjalan, 2>/dev/null = membuang pesan eror jk ada
check_crontab() {
    crontab -l 2>/dev/null | grep -q "$1"
}

# fungsi u. menampilkan crontab yg sdg berjalan
show_crontab() {
    if crontab -l 2>/dev/null | grep -q '.'; then
        echo "Daftar cron job aktif:"
        crontab -l
    else
        echo "Tidak ada crontab yang sedang berjalan."
    fi
}

# looping menu
while true; do
    clear
    echo "  Crontab Manager:"
    echo "1. Tambah pemantauan CPU (Core)"
    echo "2. Hapus pemantauan CPU"
    echo "3. Tambah pemantauan RAM (Fragment)"
    echo "4. Hapus pemantauan RAM"
    echo "5. Lihat daftar cron job aktif"
    echo "6. Keluar"
    read -p "  Pilih menu [1-6]: " choice

# crontab -l = melihat cron job yg sedang berjalan

    case $choice in
        1)
            # tambah pantauan CPU per 1 menit
            (crontab -l 2>/dev/null; echo "* * * * * $CPU_SCRIPT") | crontab -
            echo "Pemantauan CPU telah dibuat untuk setiap 1 menit."
            ;;

        2)
            # menghapus pemantauan CPU. -v = menghapus | mengupdate list ny
            if
		check_crontab "$CPU_SCRIPT"; then 
		crontab -l | grep -v "$CPU_SCRIPT" | crontab -
		echo "Pemantauan CPU telah dihapus."
            else
		echo "Tidak ada crontab yg dapat dihapus"
            fi
            ;;

        3)
            # tambah pemantauan RAM per 1 menit
            (crontab -l 2>/dev/null; echo "* * * * * $RAM_SCRIPT") | crontab -
            echo "Pemantauan RAM telah dibuat setiap 1 menit."
            ;;

        4)
            # menghapus pemantauan RAM
	    if
		check_crontab "$RAM_SCRIPT"; then
		crontab -l | grep -v "$RAM_SCRIPT" | crontab -
		echo "Pemantauan RAM telah dihapus."
	    else
		echo "Tidak ada crontab yg dapat dihapus"
	    fi
            ;;

        5)
            show_crontab
            ;;

        6)
            echo "Keluar dari Crontab Manager."
            exit 0
            ;;

        *)
            echo "Pilih angka 1-6 !"
            ;;
    esac

    read -p "Tekan ENTER untuk kembali ke menu..."
done
