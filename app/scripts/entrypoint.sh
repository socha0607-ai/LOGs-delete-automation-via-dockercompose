#!/bin/bash
echo "Initializing microservice daemon runtime..."

while true; do
    /app/scripts/backup.sh
    echo "Sleeping for 60 seconds until next rotation check..."
    sleep 60
done
