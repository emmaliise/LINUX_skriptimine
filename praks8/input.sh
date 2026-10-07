#!/bin/bash

read_player() {
    local name
    read -p "Sisesta oma nimi: " name
    if [ -z "$name" ]; then
        player_name="Unknown"
    else
        player_name="$name"
    fi
    echo ""
    echo "Tere, $player_name! Vali 5 erinevat numbrit vahemikust 1–50."
    echo ""
}

# Abifunktsioon sisendi korrektsuse kontrolliks (tagastab return 0 või 1)
is_valid_number() {
    local num="$1"

    if [ -z "$num" ]; then
        echo "Viga: Sa ei sisestanud midagi! Proovi uuesti."
        return 1
    fi

    if ! [[ "$num" =~ ^[0-9]+$ ]]; then
        echo "Viga: Sisestatud väärtus peab olema täisarv! Proovi uuesti."
        return 1
    fi

    if [ "$num" -lt 1 ] || [ "$num" -gt 50 ]; then
        echo "Viga: Number peab olema vahemikus 1 kuni 50! Proovi uuesti."
        return 1
    fi

    return 0
}

# Abifunktsioon duplikaadi kontrolliks
is_duplicate() {
    local target="$1"
    shift
    local item

    for item in "$@"; do
        if [ "$item" -eq "$target" ]; then
            return 0 # Duplikaat leitud
        fi
    done
    return 1 # Duplikaati pole
}

read_player_numbers() {
    player_nums=()
    local i=1
    local num

    while [ $i -le 5 ]; do
        read -p "Sisesta $i. number (1-50): " num

        if ! is_valid_number "$num"; then
            continue
        fi

        if is_duplicate "$num" "${player_nums[@]}"; then
            echo "Viga: Oled numbri $num juba varem valinud! Proovi uuesti."
            continue
        fi

        player_nums+=("$num")
        echo "$num" >> player_numbers.txt
        ((i++))
    done
    echo ""
}
