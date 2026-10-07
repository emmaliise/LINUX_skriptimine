#!/bin/bash

show_header() {
    echo "========================================"
    echo "           LOTOMÄNG SIMULAATOR         "
    echo "========================================"
    echo ""
}

show_player_numbers() {
    echo "Sinu valitud numbrid:"
    for n in "${player_nums[@]}"; do
        echo "$n"
    done
    echo ""
}

show_lottery_numbers() {
    echo "Loositud võidunumbrid:"
    for l in "${lottery_nums[@]}"; do
        echo "$l"
    done
    echo ""
}

show_result() {
    echo "========================================"
    echo "Mängija: $player_name"
    echo "Tabamusi: $matches / 5"
    echo "Hinnang: $result_msg"
    echo "========================================"
    echo ""
}
