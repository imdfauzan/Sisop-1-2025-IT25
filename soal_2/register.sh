#!/bin/bash

# -p = memastikan jk folder udh ada, menghindari eror
mkdir -p ./data

# buat variabel baru yg isinya player.csv
DATA_FILE="./data/player.csv"
touch "$DATA_FILE"

# buat variabel untuk hash pw
SALT="arcarea_secure_salt"



EMAIL="$1"
USERNAME="$2"
PASSWORD="$3"


# cek jika email blm dimasukkan
if [ -z "$EMAIL" ]; then
    read -p "Masukkan email: " EMAIL
fi

if grep -q "^$EMAIL," "$DATA_FILE"; then
    echo "Email sudah terdaftar!"
    exit 1
fi

if ! validate_email "$EMAIL"; then
    echo "Format email tidak valid!"
    exit 1
fi

# cek jk username blm dimasukkan
if [ -z "$USERNAME" ]; then
    read -p "Masukkan username: " USERNAME
fi

if grep -q ",$USERNAME," "$DATA_FILE"; then
    echo "Username sudah dipakai!"
    exit 1
fi

# cek jk pw blm dimasukkan
if [ -z "$PASSWORD" ]; then
    read -s -p "Masukkan password: " PASSWORD
    echo ""
fi

if ! validate_password "$PASSWORD"; then
    echo "Password harus minimal 8 karakter, mengandung huruf besar, huruf kecil, dan angka!"
    exit 1
fi

validate_email() {
    local email="$1"
    if [[ "$email" =~ @ && "$email" =~ \. ]]; then
        return 0  # jk valid
    else
        return 1  # jk tdk valid
    fi
}

validate_password() {
    local password="$1"
    if [[ "${#password}" -ge 8 && "$password" =~ [a-z] && "$password" =~ [A-Z] && "$password" =~ [0-9] ]]; then
        return 0  # jk valid
    else
        return 1  # jk tdk valid
    fi
}

hash_password() {
    local password="$1"
    echo -n "$password$SALT" | sha256sum | awk '{print $1}'
}


# cek email apkah sdh terdaftar
if grep -q "^$EMAIL," "$DATA_FILE"; then
    echo "Email sudah terdaftar!"
    exit 1
fi

# validasi format email
if ! validate_email "$EMAIL"; then
    echo "Format email tidak valid!"
    exit 1
fi

# cek apakah username sdh ada
if grep -q ",$USERNAME," "$DATA_FILE"; then
    echo "Username sudah dipakai!"
    exit 1
fi

# validasi format password
if ! validate_password "$PASSWORD"; then
    echo "Password harus minimal 8 karakter, mengandung huruf besar, huruf kecil, dan angka!"
    exit 1
fi

# Hash password sebelum disimpan
HASHED_PASSWORD=$(hash_password "$PASSWORD")

echo "$EMAIL,$USERNAME,$HASHED_PASSWORD,$PASSWORD" >> "$DATA_FILE"
echo "Registrasi berhasil!"
