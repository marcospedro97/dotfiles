#!/bin/bash

SRC="$HOME/proj"
DEST="$HOME/OneDrive/proj-backup"

while inotifywait -r -e modify,create,delete,move "$SRC"; do
  rsync -a --delete "$SRC/" "$DEST/"
done