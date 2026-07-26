#!/bin/bash

#project backup script
SOURCE="/home/casius/projects"
DATE=$(date +"%Y-%m-%d_%H-%M-%S") 
DEST="/var/backups/project/$DATE"
LOG="/var/log/project_backup.log"
echo "Backup started: $DATE" >> "$LOG"

mkdir -p "$DEST"
cp -a "$SOURCE" "$DEST" >> "$LOG" 2>&1

if [ $? -eq 0 ]; then
    echo "Backup completed successfully: $DATE" >> "$LOG"
else
    echo "Backup failed: $DATE" >> "$LOG"
fi

