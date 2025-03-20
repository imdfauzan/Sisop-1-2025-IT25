#!/bin/bash

display_help() {
    cat << "EOF"

                     %%%#**##**##%%
                     %****%+=#++++%
            %%    %%%#*****--*++++#%%%    %%
         %%***%%%********####*#++++++++%%%+++%%
       %%*************#%%%#***%%%#*++++++++++++%%
      %***********%%@    %#**#%    @%%*+++++++++*%
    %%*********%%        %#**#%        %%+++++++++#%
    %%*******%%          %#**#%           %+++++++%%
      %****#%            %#**##            %#++++%
     %****%%            @%#**%#@            %#++++%
    %****#%             %%#**%#%             %#+++*%
 %%%%****%              %####%#%              %*+++#%%%
%*******%     %    %=*%%%%+::+%%%%*=%    %     %+++++++%
%*******%     %*+#%%*:::#-::::-#:::+%%#++%     %*++++++#
%******#%      %-::+*::*-::::::-*::++::-%      %#++++++#
%******#%      %*::*-:=+::::::::==:-*::+%      %#++++++#
%*******%      %+::*::#::::::::::%::*::+%      %*++++++#
%*******%      %-:=+::*::::::::::#-:=-:=%      %++++++*%
   @%****%     %-:=+::#::::::::::%-:=-:-%     %*+++#@
    %****%%    %+::#::*=::::::::-*::#::+%    @#+++*%
     %****%%    %+::*-:*-::::::-#:-*::+%    %%++++%
     %%****#%     %#=-#+*=::::-*=#-=#%     %#++++%%
    %********%%       %%%%%::%%%%%        %+++++++*%
    %%*********%%   %%*-=#-**-#=-*%%   %%+++++++++#%
      %**********##=--**---++---**--=##++++++++++%
       %%*********#*===#===**===#===+#+++++++++%%
         %%***%%%************++++++++++#%%*++%%
            %     %%%********+++++*%%%     %%
                    %#*******+++++#%
                    %%%##**##+**#%%%

Contoh Format Penulisan: ./pokemon_analysis.sh <file.csv> [Options]

Options:
  -h, --help         Menampilkan Pesan Bantuan seperti ini.
  -i, --info         Menampilkan Usage% dan RawUsage Tertinggi.
  -s, --sort <col>   Mengurutkan Pokemon berdasarkan Atribut yg dipilih.
                      name      Sort by Pokemon name.
                      usage     Sort by Adjusted Usage.
                      rawusage  Sort by Raw Usage.
                      hp        Sort by HP.
                      atk       Sort by Attack.
                      def       Sort by Defense.
                      spdef     Sort by Special Defense.
                      speed     Sort by Speed.
  -g, --grep <name>  Cari Pokemon berdasarkan nama, hasil diurutkan berdasarkan Usage%.
  -f, --filter <type> Cari Pokemon berdasarkan tipe (Type1 atau Type2), hasil diurutkan berdasarkan Usage%.

Contoh:
  ./pokemon_analysis.sh pokemon_usage.csv --info
  ./pokemon_analysis.sh pokemon_usage.csv --sort usage
  ./pokemon_analysis.sh pokemon_usage.csv --grep pikachu
  ./pokemon_analysis.sh pokemon_usage.csv --filter electric

EOF
}

# ngecek jumlah argumen apkah masih <2 ?
if [ $# -lt 2 ]; then
    echo "Format Penulisan: ./pokemon_analysis.sh <file.csv> --info"
    exit 1
fi

# ngambil argumen dr comand yg kita ketik
FILE="$1"
OPTION="$2"
COLUMN="$3"


usagetertinggi() {
    awk -F ',' 'NR > 1 {
	if ($2>maxUsage) {maxUsage=$2; name=$1}
	}
 
    END {printf"Pokemon dengan Usage% Tertinggi: %s dengan %.4f%%\n" ,name,maxUsage}' "$FILE"
}

rawusagetertinggi() {
    awk -F ',' 'NR > 1 {
	if ($3 > maxRaw) {maxRaw=$3; name=$1}
	} 

    END {printf"Pokemon dengan RawUsage Tertinggi: %s dengan %d buah\n" ,name,maxRaw}' "$FILE"
}

sort_data() {
    local column_name="$1"

    # buat header
    header=$(head -n 1 "$FILE")

    column_index=$(echo "$header" | tr ',' '\n' | nl -w1 -s',' | grep -i "$column_name" | cut -d',' -f1 | head -n 1)

    if [ -z "$column_index" ]; then
        echo "Kolom '$column_name' tidak ditemukan dalam file CSV!"
        exit 1
    fi


    echo "$header"

    # cek apkah kolom yg dipilih adlah kolom name?
    if [ "$column_name" == "Name" ]; then

        # sorting nama (alfabet A-Z)
        tail -n +2 "$FILE" | sort -t',' -k"$column_index"

    else
        # sorting angka (usage, rawusage, dll) (besar ke kecil)
        tail -n +2 "$FILE" | sort -t',' -k"$column_index" -nr

    fi
}

matched(){
    if [ -z "$COLUMN" ]; then
        echo "Berikan Nama Pokemon yg Ingin dicari!"
        exit 1
    fi

    matched_pokemon=$(awk -F',' -v name="$COLUMN" 'tolower($1) == tolower(name)' "$FILE")

    # pesan jk tdk ditemukan
    if [ -z "$matched_pokemon" ]; then
        echo "Pokemon \"$COLUMN\" tidak ditemukan."
        exit 1
    fi

    # tampilkan header
    head -n 1 "$FILE"

    # menampilkan hasil & mengurutkan bdsr kolom Usage%
    awk -F',' -v name="$COLUMN" 'tolower($1) == tolower(name)' "$FILE" | sort -t',' -k2 -nr

}

filter_type() {
    type_name="$COLUMN"

    if [ -z "$type_name" ]; then
        echo "Masukkan Tipe Pokemon yang ingin dicari!"
        exit 1
    fi

    # tampilkan header
    head -n 1 "$FILE"

    # cari pokemon bdsr tipe 1/2, lalu urutkan berdasarkan Usage%
    awk -F',' -v type="$type_name" '
        NR > 1 && (tolower($4) == tolower(type) || tolower($5) == tolower(type))
    ' "$FILE" | sort -t',' -k2 -nr
}

# periksa apakah file sumber (csv) ada ?
if [ ! -f "$FILE" ]; then
    echo "File '$FILE' Tidak Ditemukan!"
    exit 1
fi

# periksa jika argumen fungsi (sort, grep, filter) tdk dimasukkan
case "$OPTION" in
    --sort|--grep|--filter)
        if [ -z "$COLUMN" ]; then
            echo "Anda belum memasukkan argumen apa dari fungsi $OPTION"
            exit 1
        fi
        ;;
    -h|--help)
        display_help
        ;;
esac


if [ "$OPTION" == "--info" ]; then
    echo "Summary of $FILE"
    usagetertinggi
    rawusagetertinggi

elif [ "$OPTION" == "--sort" ]; then
    sort_data "$COLUMN"

elif [ "$OPTION" == "--grep" ]; then
    matched 

elif [ "$OPTION" == "--filter" ]; then
    filter_type

else
    echo "OPSI TIDAK DIKENALI"
    exit 1
fi

