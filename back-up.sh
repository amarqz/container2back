#!/bin/sh

# Define the folders to back up and the destination directory from environment variables
KEY_ID=${KEY_ID}
BACKUP_PREFIX=${BACKUP_PREFIX:-"backup"}
DATE=$(date +%Y%m%d%H%M%S)
ARCHIVE_NAME="${BACKUP_PREFIX}_$DATE.tar.xz"
ENCRYPTED_ARCHIVE_NAME="$ARCHIVE_NAME.gpg"
MAX_BACKUPS=${MAX_BACKUPS:-5}

# Create the compressed archive using xz
cd /srv && tar -cJf "bk/$ARCHIVE_NAME" to_back_up

# Encrypt the archive using the PGP key
gpg --encrypt --recipient "$KEY_ID" "bk/$ARCHIVE_NAME"

# Optional: Remove the unencrypted archive
rm "bk/$ARCHIVE_NAME"

echo "Backup and encryption completed: /srv/bk/$ENCRYPTED_ARCHIVE_NAME"

# Retain only the most recent backups
BACKUP_COUNT=$(ls -1t bk/${BACKUP_PREFIX}*.tar.xz.gpg | wc -l)
if [ $BACKUP_COUNT -gt $MAX_BACKUPS ]; then
    ls -1t bk/${BACKUP_PREFIX}*.tar.xz.gpg | tail -n +$(($MAX_BACKUPS + 1)) | xargs rm --
    echo "Removed older backups, keeping only the most recent $MAX_BACKUPS backups."
fi