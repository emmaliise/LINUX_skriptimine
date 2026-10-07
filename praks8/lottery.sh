#!/bin/bash

# 1. Tühjenda või loo vajalikud ajutised failid
> player_numbers.txt
> lottery_numbers.txt

# 2. Küsi mängija nime (vaikeväärtus: Unknown)
read -p "Sisesta oma nimi: " player_name
if [ -z "$player_name" ]; then
    player_name="Unknown"
fi

echo ""
echo "Tere, $player_name! Vali 5 erinevat numbrit vahemikust 1–50."
echo ""

# 3. Mängija numbritesisestus ja kontroll
player_nums=()
i=1

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

    # Kontroll 4: kas same number on juba valitud
    already_chosen=0
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

    # Salvesta korrektne number
    player_nums+=("$num")
    echo "$num" >> player_numbers.txt
    ((i++))
done

echo ""
echo "Sinu valitud numbrid:"
for n in "${player_nums[@]}"; do
    echo "$n"
done
echo ""

# 4. Võidunumbrite loosimine ($RANDOM)
echo "Käib võidunumbrite loosimine..."
lottery_nums=()

while [ ${#lottery_nums[@]} -lt 5 ]; do
    rand_num=$(( RANDOM % 50 + 1 ))

    # Kontrolli duplikaate
    duplicate=0
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

echo "Loositud võidunumbrid:"
for l in "${lottery_nums[@]}"; do
    echo "$l"
done
echo ""

# 5. Tulemuste kontrollimine
echo "--- TULEMUSTE KONTROLL ---"
matches=0

for p_num in "${player_nums[@]}"; do
    echo "Kontrollin numbrit $p_num..."

    is_match=0
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

# Hinnangu määramine vastavalt tabamustele
case $matches in
    5) result_msg="JACKPOT!" ;;
    4) result_msg="Väga hea tulemus!" ;;
    3) result_msg="Hea tulemus." ;;
    2) result_msg="Kaks tabamust." ;;
    1) result_msg="Üks tabamus." ;;
    0) result_msg="Seekord tabamusi ei olnud." ;;
esac

echo "========================================"
echo "Mängija: $player_name"
echo "Tabamusi: $matches / 5"
echo "Hinnang: $result_msg"
echo "========================================"

# 6. Tulemuse lisamine ajalogisse (results.txt)
current_date=$(date)

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

echo ""
echo "Mängu tulemus lisati faili results.txt!"
