#!/bin/bash

# Määrame sihtkataloogi (töötab sõltumata käivitamise asukohast)
DEST_DIR="$HOME/home_bcp"
DATE_STAMP=$(date +%d.%m.%Y)

# Tekitame sihtkataloogi, kui seda pole olemas
mkdir -p "$DEST_DIR"

echo "=== Alustan kasutajate kodukataloogide varundamist ==="
echo "Sihtkoht: $DEST_DIR"
echo "Kuupäev: $DATE_STAMP"
echo "----------------------------------------------------"

# Läbime kõik /home kaustas olevad kasutajakataloogid
for user_dir in /home/*; do
    # Kontrollime, kas tegemist on kataloogiga
    if [ -d "$user_dir" ]; then
        username=$(basename "$user_dir")
        archive_name="${username}.${DATE_STAMP}.tar.gz"
        
        echo "Varundan kasutajat: $username -> $archive_name"
        
        # Paki kasutaja kaust asukohast sõltumatult (-C /home)
        tar -czf "$DEST_DIR/$archive_name" -C /home "$username" 2>/dev/null
        
        if [ $? -eq 0 ]; then
            echo " [OK] $username varundatud."
        else
            echo " [VIGA] Kasutaja $username varundamine ebaõnnestus (vajadusel kasuta sudo)!"
        fi
    fi
done

echo "----------------------------------------------------"
echo "Varundamine lõpetatud. Arhiivid asuvad: $DEST_DIR"
