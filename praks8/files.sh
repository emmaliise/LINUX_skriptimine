#!/bin/bash

# Tühjendab või loob vajalikud tööfailid
clear_files() {
    > player_numbers.txt
    > lottery_numbers.txt
}

# Salvestab mängu tulemused faili results.txt
save_result() {
    local player="$1"
    local matches="$2"
    local result_msg="$3"
    shift 3

    local p_nums=("${@:1:5}")
    local l_nums=("${@:6:5}")
    local current_date
    current_date=$(date)

    {
        echo "========================================"
        echo "Date: $current_date"
        echo "Player: $player"
        echo "Player numbers:"
        for p in "${p_nums[@]}"; do
            echo "$p"
        done
        echo "Lottery numbers:"
        for l in "${l_nums[@]}"; do
            echo "$l"
        done
        echo "Matches: $matches"
        echo "Result: $result_msg"
    } >> results.txt

    echo "Mängu tulemus lisati faili results.txt!"
}
