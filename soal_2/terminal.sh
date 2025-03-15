#!/bin/bash


REGISTER_SCRIPT="./register.sh"
LOGIN_SCRIPT="./login.sh"
CRONTAB_MANAGER="./scripts/manager.sh"

# Fungsi untuk menampilkan menu utama
main_menu() {
    while true; do
        clear
        echo "   Arcaea System Menu"
        echo "1. Register"
        echo "2. Login"
        echo "3. Exit"
        echo ""
        read -p "Pilih menu: " choice

        case "$choice" in
            1) register;;
            2) login ;;
            3) echo "Keluar dari sistem."; exit 0 ;;
            *) echo "Pilihan tidak valid!"; sleep 1 ;;
        esac
    done
}


register() {
    bash "$REGISTER_SCRIPT"
    read -p "Tekan enter untuk kembali ke menu..."
}

# Fungsi Login
login() {
    bash "$LOGIN_SCRIPT"
    if [ $? -eq 0 ]; then
        logged_in_menu
    else
        echo "Login gagal. Kembali ke menu utama."
        sleep 1
    fi
}

# Menu setelah berhasil login
logged_in_menu() {
    while true; do
        clear
        echo "=============================="
        echo "      Logged-in Menu         "
        echo "=============================="
        echo "1. Crontab Manager"
        echo "2. Logout"
        echo "=============================="
        read -p "Pilih menu: " choice

        case "$choice" in
            1) bash "$CRONTAB_MANAGER" ;;
            2) echo "Logout berhasil."; sleep 1; break ;;
            *) echo "Pilihan tidak valid!"; sleep 1 ;;
        esac
    done
}

# Jalankan menu utama
main_menu
