#!/bin/bash

Speak_To_Me() {
    clear
    delay=1

    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    MAGENTA='\033[0;35m'
    CYAN='\033[0;36m'
    NC='\033[0m'

    while true; do
        response=$(curl -s -H "Accept: application/json" "https://www.affirmations.dev")
        affirmation=$(echo "$response" | jq -r '.affirmation')

        if [[ -z "$affirmation" ]]; then
            echo -e "${RED}Failed to fetch affirmation. Retrying...${NC}"
        else
            colors=("$GREEN" "$YELLOW" "$BLUE" "$MAGENTA" "$CYAN")
            random_color=${colors[$RANDOM % ${#colors[@]}]}
            echo -e "${random_color}$affirmation${NC}"
        fi

        sleep "$delay"
    done
}

On_The_Run() {
    total_steps=50

    clear
    progress_bar() {
        local current=$1
        local total=$2
        local width=$(tput cols)
        local bar_width=$((width - 16))

        local percent=$((current * 100 / total))
        local progress=$((current * bar_width / total))

        local bar="["
        for ((j = 0; j < bar_width; j++)); do
            if [[ $j -lt $progress ]]; then
                bar+="#"
            else
                bar+=" "
            fi
        done
        bar+="]"

        printf "\rProgress: %s %d%%" "$bar" "$percent"
    }

    for ((i = 0; i <= total_steps; i++)); do
        progress_bar "$i" "$total_steps"
        delay=$((RANDOM % 900 + 100))
        sleep "$(echo "scale=3; $delay/1000" | bc)"
    done
    echo
}

Money() {
    blue="\033[0;34m"
    brightblue="\033[1;34m"
    cyan="\033[0;36m"
    brightcyan="\033[1;36m"
    green="\033[0;32m"
    brightgreen="\033[1;32m"
    red="\033[0;31m"
    brightred="\033[1;31m"
    white="\033[1;37m"
    black="\033[0;30m"
    grey="\033[0;37m"
    darkgrey="\033[1;30m"

    colors=($blue $red $black $grey $green $brightgreen $cyan $white $brightblue)

    spacing=${1:-100}
    scroll=${2:-0}
    screenlines=$(expr $(tput lines) - 1 + $scroll)
    screencols=$(expr $(tput cols) / 2 - 1)

    chars=(ｱ ｲ ｳ ｴ ｵ ｶ ｷ ｸ ｹ ｺ ｻ ｼ ｽ ｾ ｿ ﾀ ﾁ ﾂ ﾃ ﾄ ﾅ ﾆ ﾇ ﾈ ﾉ ﾊ ﾋ ﾌ ﾍ ﾎ ﾏ ﾐ ﾑ)
	clear
    count=${#chars[@]}
    colorcount=${#colors[@]}

    trap "tput sgr0; clear; exit" SIGTERM SIGINT

    if [[ $1 =~ '-h' ]]; then
        echo "Display a Matrix(ish) screen in the terminal"
        echo "Usage:            matrix [SPACING [SCROLL]]"
        echo "Example:  matrix 100 0"
        exit 0
    fi

    tput cup 0 0
    while :; do
        for i in $(eval echo {1..$screenlines}); do
            for j in $(eval echo {1..$screencols}); do
                rand=$(($RANDOM % $spacing))
                case $rand in
                    0)
                        printf "${colors[$RANDOM % $colorcount]}${chars[$RANDOM % $count]} "
                        ;;
                    1)
                        printf "  "
                        ;;
                    *)
                        printf "\033[2C"
                        ;;
                esac
            done
            printf "\n"
        done
        tput cup 0 0
    done
}

Time() {
    live_clock() {
        RED='\033[0;31m'
        GREEN='\033[0;32m'
        YELLOW='\033[1;33m'
        BLUE='\033[0;34m'
        MAGENTA='\033[0;35m'
        CYAN='\033[0;36m'
        NC='\033[0m'

        while true; do
            current_date=$(date +"%Y-%m-%d")
            current_day=$(date +"%A")
            current_time=$(date +"%H:%M:%S")

            clear
            printf "${GREEN}Date: ${NC}${RED}%s${NC} | ${GREEN}Day: ${NC}${YELLOW}%s${NC} | ${GREEN}Time: ${NC}${BLUE}%s${NC}\n" "$current_date" "$current_day" "$current_time"
            sleep 1
        done
    }

    live_clock
}

Brain_Damage() {
    colors=("31" "32" "33" "34" "35" "36" "91" "92" "93" "94" "95" "96")

    show_processes() {
        while true; do
            clear
            echo -e "\e[1;36mReal-Time Task Manager (Update setiap 1 detik)\e[0m"
            echo -e "\e[1;36m---------------------------------------------\e[0m"

            top_output=$(top -b -n 1 -d 1 | head -n 12)

            line_number=0
            while IFS= read -r line; do
                color="${colors[line_number % ${#colors[@]}]}"
                echo -e "\e[1;${color}m${line}\e[0m"
                line_number=$((line_number + 1))
            done <<< "$top_output"

            sleep 1
        done
    }

    show_processes
}

show_help() {
    echo "Penggunaan: ./dsotm.sh --play=\"<Track>\""
    echo "Contoh: ./dsotm.sh --play=\"Track1\""
}

if [[ "$1" == "--play="* ]]; then
    Track=$(echo "$1" | cut -d '=' -f 2)
else
    echo "Error: Argumen tidak valid."
    show_help
    exit 1
fi

if [ "$Track" == "Speak To Me" ]; then
    Speak_To_Me
elif [ "$Track" == "On The Run" ]; then
    On_The_Run
elif [ "$Track" == "Money" ]; then
    Money
elif [ "$Track" == "Time" ]; then
    Time
elif [ "$Track" == "Brain Damage" ]; then
    Brain_Damage
else
    echo "Error: Track tidak dikenali."
    echo "Daftar Track yang tersedia:"
    echo "  Speak to Me"
    echo "  On the Run"
    echo "  Money"
    echo "  Time"
    echo "  Brain Damage"
    exit 1
fi
