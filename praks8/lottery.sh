#!/bin/bash

# Teeme kindlaks skripti asukohakausta
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Laadime vajalikud funktsioonide failid
source "$DIR/files.sh"
source "$DIR/input.sh"
source "$DIR/lottery_functions.sh"
source "$DIR/result.sh"

# Globaalsed muutuja-konteinerid
player_name="Unknown"
player_nums=()
lottery_nums=()
matches=0
result_msg=""

# ==========================================
# PROGRAMMI PEAMINE TÖÖVOOG
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
save_result "$player_name" "$matches" "$result_msg" "${player_nums[@]}" "${lottery_nums[@]}"
