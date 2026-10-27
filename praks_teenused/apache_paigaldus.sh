#!/bin/bash
# =========================================================
# Skript: apache_paigaldus.sh
# Kirjeldus: Kontrollib apache2 teenuse olemasolu. Kui teenus
#            puudub, paigaldab selle. Kui on olemas, kuvab
#            teenuse staatuse.
# =========================================================

# Kontrollime, kas skript käivitatakse root-õigustes (apt vajab seda)
if [ "$EUID" -ne 0 ]; then
    echo "Viga: Seda skripti tuleb käivitada root-õigustes (kasuta: sudo $0)"
    exit 1
fi

# Tuvastame apache2 oleku dpkg-query ja grep -c abil
# -c annab leitud ridade arvu (1 = paigaldatud, 0 = ei ole paigaldatud)
APACHE2=$(dpkg-query -W -f='${Status}' apache2 2>/dev/null | grep -c "ok installed")

# Tingimuslause kontroll
if [ "$APACHE2" -eq 1 ]; then
    echo "--------------------------------------------------"
    echo "TEAVE: apache2 teenus on juba süsteemi paigaldatud."
    echo "--------------------------------------------------"
    echo "Kuvandatakse teenuse hetkeseisund:"
    systemctl status apache2 --no-pager
else
    echo "--------------------------------------------------"
    echo "HOIATUS: apache2 teenust ei leitud süsteemist."
    echo "Alustan teenuse paigaldamist..."
    echo "--------------------------------------------------"
    
    # Uuendame pakettide nimekirja ja paigaldame apache2
    apt-get update
    apt-get install -y apache2
    
    if [ $? -eq 0 ]; then
        echo "--------------------------------------------------"
        echo "OK: apache2 paigaldamine õnnestus edukalt!"
        echo "--------------------------------------------------"
        echo "Teenuse olek pärast paigaldamist:"
        systemctl status apache2 --no-pager
    else
        echo "--------------------------------------------------"
        echo "VIGA: apache2 paigaldamisel tekkis tõrge!"
        echo "--------------------------------------------------"
        exit 1
    fi
fi
