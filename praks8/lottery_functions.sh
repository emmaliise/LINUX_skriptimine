#!/bin/bash

generate_lottery_numbers() {
    lottery_nums=()
    echo "Käib võidunumbrite loosimine..."

    while [ ${#lottery_nums[@]} -lt 5 ]; do
        local rand_num=$(( RANDOM % 50 + 1 ))

        if ! is_duplicate "$rand_num" "${lottery_nums[@]}"; then
            lottery_nums+=("$rand_num")
            echo "$rand_num" >> lottery_numbers.txt
        fi
    done
}

check_matches() {
    echo "--- TULEMUSTE KONTROLL ---"
    matches=0

    for p_num in "${player_nums[@]}"; do
        echo "Kontrollin numbrit $p_num..."

        if is_duplicate "$p_num" "${lottery_nums[@]}"; then
            echo "TABAMUS!"
            ((matches++))
        else
            echo "Ei tabanud."
        fi
        echo ""
    done

    get_rating_message "$matches"
}

get_rating_message() {
    local count="$1"
    case "$count" in
        5) result_msg="JACKPOT!" ;;
        4) result_msg="Väga hea tulemus!" ;;
        3) result_msg="Hea tulemus." ;;
        2) result_msg="Kaks tabamust." ;;
        1) result_msg="Üks tabamus." ;;
        0) result_msg="Seekord tabamusi ei olnud." ;;
    esac
}
