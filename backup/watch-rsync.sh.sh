#!/bin/bash

SRC="$HOME/proj/"
DEST="$HOME/OneDrive/proj-backup/"
LOGFILE="$HOME/.scripts/rsync-watcher.log"

mkdir -p "$DEST"
mkdir -p "$(dirname "$LOGFILE")"

echo "===== $(date '+%Y-%m-%d %H:%M:%S') - Watcher started =====" >> "$LOGFILE"

inotifywait -mr \
  -e modify,create,delete,move,attrib,close_write,moved_to,moved_from \
  "$SRC" | while read -r path event file; do
  echo "----- $(date '+%Y-%m-%d %H:%M:%S') - Event: $event | File: $file | Path: $path" >> "$LOGFILE"

  rsync -av --delete "$SRC" "$DEST" >> "$LOGFILE" 2>&1

  if [ $? -eq 0 ]; then
    echo "----- $(date '+%Y-%m-%d %H:%M:%S') - rsync completed successfully -----" >> "$LOGFILE"
  else
    echo "----- $(date '+%Y-%m-%d %H:%M:%S') - rsync failed -----" >> "$LOGFILE"
  fi
done
