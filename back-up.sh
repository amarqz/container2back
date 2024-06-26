#!/bin/sh

# Define variables (from environment or default values)
DATE=$(date +%Y%m%d%H%M%S)

KEY_ID=${KEY_ID}
MAX_BACKUPS=${MAX_BACKUPS:-5}

BACKUP_PREFIX=${BACKUP_PREFIX:-"backup"}
ARCHIVE_NAME="${BACKUP_PREFIX}_$DATE.tar.xz"
ENCRYPTED_ARCHIVE_NAME="$ARCHIVE_NAME.gpg"

DESTINATION=${DESTINATION:-""}
REMOTE_PORT=${REMOTE_PORT:-22}
REMOTE_LOCATION=${REMOTE_LOCATION:-"backups"}

echo "[$(date +"%d/%m/%Y %H:%M:%S")] Starting back-up..."

# Create the compressed archive using xz
cd /srv && tar -cJf "bk/$ARCHIVE_NAME" to_back_up
echo "[$(date +"%d/%m/%Y %H:%M:%S")] Created compressed folder."

# Encrypt the archive using the PGP key
gpg --encrypt --recipient "$KEY_ID" "bk/$ARCHIVE_NAME"
echo "[$(date +"%d/%m/%Y %H:%M:%S")] Compressed folder successfully encrypted."

# Optional: Remove the unencrypted archive
rm "bk/$ARCHIVE_NAME"

if [ -n $DESTINATION ]; then
    # Send the back-up file to the destination server
    rsync -avz -e "ssh -p $REMOTE_PORT" bk/$ENCRYPTED_ARCHIVE_NAME $DESTINATION:$REMOTE_LOCATION
    ssh ${DESTINATION} -p $REMOTE_PORT "sh & find $REMOTE_LOCATION -type 'f' | sort -rn | tail -n +$(($MAX_BACKUPS + 1)) | cut -d' ' -f2- | xargs rm -f"
    rm bk/$ENCRYPTED_ARCHIVE_NAME
fi

if [ -z $DESTINATION ]; then
    # Retain only the most recent backups
    BACKUP_COUNT=$(ls -1t bk/${BACKUP_PREFIX}*.tar.xz.gpg | wc -l)
    if [ $BACKUP_COUNT -gt $MAX_BACKUPS ]; then
        ls -1t bk/${BACKUP_PREFIX}*.tar.xz.gpg | tail -n +$(($MAX_BACKUPS + 1)) | xargs rm --
        echo "[$(date +"%d/%m/%Y %H:%M:%S")] Removed older backups, keeping only the most recent $MAX_BACKUPS backups."
    fi
fi

echo "[$(date +"%d/%m/%Y %H:%M:%S")] Backup and encryption completed: $ENCRYPTED_ARCHIVE_NAME"