#!/bin/bash
LOG_DIR="/var/log/app"
BACKUP_DIR="/var/backups/app"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="${BACKUP_DIR}/log_backup_${TIMESTAMP}.tar.gz"

echo "[\$(date)] Starting log compression and cleanup rotation..."

if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR"
fi

if [ "\$(ls -A \$LOG_DIR)" ]; then
    tar -czf "$BACKUP_FILE" -C "$LOG_DIR" .
    echo "[\$(date)] Successfully backed up logs to \$BACKUP_FILE"
    truncate -s 0 \$LOG_DIR/*.log
    echo "[\$(date)] App logs truncated successfully."
else
    echo "[\$(date)] No logs found to backup."
fi
