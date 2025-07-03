SRC="$HOME/proj/"
DEST="$HOME/OneDrive/proj-backup/"
LOGFILE="$HOME/.scripts/rsync-watcher.log"

mkdir -p "$SRC" "$DEST"
mkdir -p "$(dirname "$LOGFILE")"
touch "$LOGFILE"
chmod 600 "$LOGFILE"

echo "===== $(date '+%Y-%m-%d %H:%M:%S') - Watcher started =====" >> "$LOGFILE"

# Etapa 1: Restauração inicial
if [ "$(ls -A "$DEST" 2>/dev/null)" ]; then
  echo "[INFO] Restoring backup..." >> "$LOGFILE"
  rsync -a "$DEST" "$SRC" >> "$LOGFILE" 2>&1
fi

# Etapa 2: Início do watcher
inotifywait -mr -e modify,create,delete,move,close_write "$SRC" | while read -r path event file; do
  FILE_COUNT=$(find "$SRC" -type f | wc -l)

  echo "[EVENT] $event $file" >> "$LOGFILE"
  if [ "$FILE_COUNT" -lt 10 ]; then
    echo "[WARN] SRC has too few files ($FILE_COUNT). Skipping sync." >> "$LOGFILE"
    continue
  fi

  rsync -av "$SRC" "$DEST" >> "$LOGFILE" 2>&1 && \
    echo "[OK] Sync success at $(date)" >> "$LOGFILE" || \
    echo "[FAIL] Sync failed at $(date)" >> "$LOGFILE"
done
