#!/bin/bash

# =========================================================
# Täielik varundamise ja kontrollimise skript (backupexec.sh)
# =========================================================

SRC_DIR="$HOME/praks2/src"
BACKUP_DIR="$HOME/praks2/backup"
LOG_DIR="$HOME/praks2/logs"
LOG_FILE="$LOG_DIR/backup.log"
IGNORE_FILE="$SRC_DIR/.backupignore"
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
ARCHIVE_NAME="src_${TIMESTAMP}.tar.zst"
ARCHIVE_PATH="$BACKUP_DIR/$ARCHIVE_NAME"

# Luuakse vajalikud kaustad
mkdir -p "$BACKUP_DIR" "$LOG_DIR"

# 1. Ajutise töökausta tekitamine ja automaatne puhastus (trap)
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

log_msg() {
    local msg="[ $(date '+%F %T') ] $1"
    echo "$msg"
    echo "$msg" >> "$LOG_FILE"
}

log_msg "--- ALUSTAN VARUNDUSPROTSESSI ---"

# 2. Vaba ruumi kontroll
if [ ! -d "$SRC_DIR" ]; then
    log_msg "[VIGA] Lähtekaust $SRC_DIR puudub!"
    exit 1
fi

SRC_SIZE=$(du -sb "$SRC_DIR" | awk '{print $1}')
FREE_SPACE=$(df -B1 "$BACKUP_DIR" | awk 'NR==2{print $4}')

log_msg "Lähtekausta suurus: ${SRC_SIZE} baiti | Vaba ruum: ${FREE_SPACE} baiti"

if [ "$FREE_SPACE" -le "$SRC_SIZE" ]; then
    log_msg "[VIGA] Kettal pole piisavalt vaba ruumi!"
    exit 1
fi

# 3. .backupignore kontroll ja pakkimine
EXTRA_OPTS=()
if [ -f "$IGNORE_FILE" ]; then
    log_msg "Leiti .backupignore fail, rakendan välistused."
    EXTRA_OPTS+=("--exclude-from=$IGNORE_FILE")
fi

log_msg "Loon arhiivi: $ARCHIVE_NAME (zstd kompressoriga)"
tar "${EXTRA_OPTS[@]}" -I 'zstd -19 -T0' -cf "$ARCHIVE_PATH" -C "$(dirname "$SRC_DIR")" "$(basename "$SRC_DIR")"

if [ $? -ne 0 ]; then
    log_msg "[VIGA] Arhiivi loomine ebaõnnestus!"
    exit 1
fi

# 4. Arhiivi suuruse kuvamine
ARCHIVE_SIZE=$(du -h "$ARCHIVE_PATH" | awk '{print $1}')
log_msg "Loodud arhiivi suurus: $ARCHIVE_SIZE"

# 5. Arhiivi tervikluse kontroll (-tf)
log_msg "Kontrollin arhiivi loetavust..."
tar -I 'zstd -d' -tf "$ARCHIVE_PATH" > /dev/null 2>&1
if [ $? -eq 0 ]; then
    log_msg "[OK] Arhiiv on struktuurselt korras."
else
    log_msg "[VIGA] Arhiiv on vigane või kahjustatud!"
    exit 1
fi

# 6. SHA-256 kontrollsumma arvutamine ja kontroll
log_msg "Genereerin SHA-256 kontrollsumma..."
cd "$BACKUP_DIR" || exit 1
sha256sum "$ARCHIVE_NAME" > "${ARCHIVE_NAME}.sha256"

sha256sum -c "${ARCHIVE_NAME}.sha256" > /dev/null 2>&1
if [ $? -eq 0 ]; then
    log_msg "[OK] SHA-256 kontrollsumma klapib."
else
    log_msg "[VIGA] SHA-256 kontrollsumma ei klapi!"
    exit 1
fi

# 7. Vana varukoopiate puhastus (hoitakse alles ainult 3 viimast)
log_msg "Puhastan vanad arhiivid (jäetakse alles 3 viimast)..."
ls -1t src_*.tar.zst 2>/dev/null | tail -n +4 | while read -r old_archive; do
    log_msg "Eemaldan vana arhiivi: $old_archive"
    rm -f "$old_archive" "${old_archive}.sha256"
done

log_msg "--- VARUNDUS PROTSESS ÕNNESTUS EDUKALT ---"
