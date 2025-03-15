#!/bin/bash

DATA_FILE="./data/player.csv"

email="$1"
password="$2"

if [ -z "$email" ]; then
    read -p "Masukkan email: " email
fi

if [ -z "$password" ]; then
    read -s -p "Masukkan password: " password
fi


# cek email dan pw
if grep -q "^$email,.*,.*,${password}$" "$DATA_FILE"; then
    echo "Login berhasil! Selamat datang"
else
    echo "Login gagal! Cek email atau password."
    exit 1
fi
