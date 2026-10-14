#!/bin/bash

BACKUP_DIR="$HOME/praks2/backup"
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
ARCHIVE_NAME="src_${TIMESTAMP}.tar.zst"
ARCHIVE_PATH="${BACKUP_DIR}/${ARCHIVE_NAME}"

# Tekita varunduse kaust, kui seda pole
mkdir -p "$BACKUP_DIR"

# Loo arhiiv
tar --zstd -cf "$ARCHIVE_PATH" -C "$HOME/LINUX_skriptimine" .

# Arvuta SHA-256 kontrollsumma
cd "$BACKUP_DIR" || exit 1
sha256sum "$ARCHIVE_NAME" > "${ARCHIVE_NAME}.sha256"

echo "Arhiiv loodud: $ARCHIVE_PATH"
echo "Kontrollsumma salvestatud: ${ARCHIVE_PATH}.sha256"
