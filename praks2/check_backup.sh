#!/bin/bash

BACKUP_DIR="$HOME/praks2/backup"

if [ ! -d "$BACKUP_DIR" ]; then
    echo "Viga: Kausta $BACKUP_DIR ei eksisteeri!"
    exit 1
fi

cd "$BACKUP_DIR" || exit 1

echo "Käivitan kõigi arhiivide SHA-256 kontrolli..."

# Luuakse koondfail ja kontrollitakse kõiki .tar.zst faile
find . -maxdepth 1 -type f -name 'src_*.tar.zst' -print0 | xargs -0 sha256sum > checksums.txt
sha256sum -c checksums.txt

# Kustutatakse ajutine koondfail
rm checksums.txt
