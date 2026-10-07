#!/bin/bash

# Global muutujad
player_name="Unknown"
player_nums=()
lottery_nums=()
matches=0
result_msg=""

# ==========================================
# FUNKTSIOONIDE DEFINITSIOONID
# ==========================================

show_header() {
    echo "========================================"
    echo "           LOTOMÄNG SIMULAATOR         "
    echo "========================================"
    echo ""
}

clear_files() {
    > player_numbers.txt
    > lottery_numbers.txt
}

read_player() {
    read -p "Sisesta oma nimi: " name
    if [ -n "$name" ]; then
        player_name="$name"
    fi
    echo ""
    echo "Tere, $player_name! Vali 5 erinevat numbrit vahemikust 1–50."
    echo ""
}

read_player_numbers() {
    local i=1
    while [ $i -le 5 ]; do
        read -p "Sisesta $i. number (1-50): " num

        # Kontroll 1: kas sisend on tühi
        if [ -z "$num" ]; then
            echo "Viga: Sa ei sisestanud midagi! Proovi uuesti."
            continue
        fi

        # Kontroll 2: kas sisestatud väärtus on täisarv
        if ! [[ "$num" =~ ^[0-9]+$ ]]; then
            echo "Viga: Sisestatud väärtus peab olema täisarv! Proovi uuesti."
            continue
        fi

        # Kontroll 3: kas number on vahemikus 1–50
        if [ "$num" -lt 1 ] || [ "$num" -gt 50 ]; then
            echo "Viga: Number peab olema vahemikus 1 kuni 50! Proovi uuesti."
            continue
        fi

        # Kontroll 4: kas sama number on juba valitud
        local already_chosen=0
        for prev in "${player_nums[@]}"; do
            if [ "$prev" -eq "$num" ]; then
                already_chosen=1
                break
            fi
        done

        if [ "$already_chosen" -eq 1 ]; then
            echo "Viga: Oled numbri $num juba varem valinud! Proovi uuesti."
            continue
        fi

        player_nums+=("$num")
        echo "$num" >> player_numbers.txt
        ((i++))
    done
    echo ""
}

show_player_numbers() {
    echo "Sinu valitud numbrid:"
    for n in "${player_nums[@]}"; do
        echo "$n"
    done
    echo ""
}

generate_lottery_numbers() {
    echo "Käib võidunumbrite loosimine..."
    while [ ${#lottery_nums[@]} -lt 5 ]; do
        local rand_num=$(( RANDOM % 50 + 1 ))
        local duplicate=0

        for l_num in "${lottery_nums[@]}"; do
            if [ "$l_num" -eq "$rand_num" ]; then
                duplicate=1
                break
            fi
        done

        if [ "$duplicate" -eq 0 ]; then
            lottery_nums+=("$rand_num")
            echo "$rand_num" >> lottery_numbers.txt
        fi
    done
}

show_lottery_numbers() {
    echo "Loositud võidunumbrid:"
    for l in "${lottery_nums[@]}"; do
        echo "$l"
    done
    echo ""
}

check_matches() {
    echo "--- TULEMUSTE KONTROLL ---"
    matches=0

    for p_num in "${player_nums[@]}"; do
        echo "Kontrollin numbrit $p_num..."
        local is_match=0

        for l_num in "${lottery_nums[@]}"; do
            if [ "$p_num" -eq "$l_num" ]; then
                is_match=1
                break
            fi
        done

        if [ "$is_match" -eq 1 ]; then
            echo "TABAMUS!"
            ((matches++))
        else
            echo "Ei tabanud."
        fi
        echo ""
    done

    case $matches in
        5) result_msg="JACKPOT!" ;;
        4) result_msg="Väga hea tulemus!" ;;
        3) result_msg="Hea tulemus." ;;
        2) result_msg="Kaks tabamust." ;;
        1) result_msg="Üks tabamus." ;;
        0) result_msg="Seekord tabamusi ei olnud." ;;
    esac
}

show_result() {
    echo "========================================"
    echo "Mängija: $player_name"
    echo "Tabamusi: $matches / 5"
    echo "Hinnang: $result_msg"
    echo "========================================"
    echo ""
}

save_result() {
    local current_date=$(date)
    {
        echo "========================================"
        echo "Date: $current_date"
        echo "Player: $player_name"
        echo "Player numbers:"
        for p in "${player_nums[@]}"; do
            echo "$p"
        done
        echo "Lottery numbers:"
        for l in "${lottery_nums[@]}"; do
            echo "$l"
        done
        echo "Matches: $matches"
        echo "Result: $result_msg"
    } >> results.txt

    echo "Mängu tulemus lisati faili results.txt!"
}

# ==========================================
# PROGRAMMI PÕHIOSA (MAIN)
# ==========================================

show_header
clear_files
read_player
read_player_numbers
show_player_numbers
generate_lottery_numbers
show_lottery_numbers
check_matches
show_result
save_result
