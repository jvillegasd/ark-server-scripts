#!/bin/bash
####################################
# Clean up ARK saved game to a
# specified folder.
#
# Give execute permission to this script:
# chmod +x clear_backups.sh
####################################

# Specify which directory to backup to.
backup_dir="/home/ark-server/backups"
file_age=7

# Verify that the backup directory exists.
if [ ! -d $backup_dir ]; then
  echo "Backup directory $backup_dir does not exist."
  exit 1
fi

# -mtime +$file_age means any file older than $file_age days
find $backup_dir -type f -mtime +$file_age -exec rm -f {} \;
