#!/bin/bash

SRC="$HOME/proj/"
DEST="$HOME/OneDrive/proj-backup/"
LOGFILE="$HOME/.scripts/rsync-watcher.log"

mkdir -p "$(dirname "$LOGFILE")"
touch "$LOGFILE"
chmod 600 "$LOGFILE"

echo "===== $(date '+%Y-%m-%d %H:%M:%S') - Watcher started =====" >> "$LOGFILE"
echo "[$(date)] Script iniciado, PID $$" >> "$LOGFILE"

# Aguarda o OneDrive ser montado (timeout de 60s)
for i in {1..60}; do
  if findmnt --target "$HOME/OneDrive" >/dev/null; then
    echo "[$(date)][INFO] OneDrive montado." >> "$LOGFILE"
    break
  fi
  sleep 1
done

if ! findmnt --target "$HOME/OneDrive" >/dev/null; then
  echo "[$(date)][ERRO] OneDrive não montado após 60s. Abortando watcher." >> "$LOGFILE"
  exit 1
fi

echo "[$(date)][INFO] Sleep para garantir que o OneDrive esteja totalmente sincronizado" >> "$LOGFILE"
sleep 60 # Espera 60 segundos para garantir que o OneDrive esteja totalmente sincronizado

# Restauração inicial: copia arquivos faltantes do backup para $SRC
if [ "$(ls -A "$DEST" 2>/dev/null)" ]; then
  echo "[$(date)][INFO] Restaurando arquivos faltantes do backup..." >> "$LOGFILE"
  rsync -av --checksum --ignore-existing "$DEST" "$SRC" >> "$LOGFILE" 2>&1
fi

# Watcher: monitora alterações em $SRC e sincroniza para $DEST
inotifywait -mr -e modify,create,delete,move,close_write "$SRC" | while read -r path event file; do
  echo "[$(date)][EVENT] $event $file" >> "$LOGFILE"
  rsync -av --checksum "$SRC" "$DEST" >> "$LOGFILE" 2>&1 && \
    echo "[$(date)][OK] Sync em $(date)" >> "$LOGFILE" || \
    echo "[$(date)][FAIL] Sync falhou em $(date)" >> "$LOGFILE"
done
