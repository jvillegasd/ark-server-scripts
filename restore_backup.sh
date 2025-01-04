#!/bin/bash
####################################
# Restore Ark server backup.
#
# Give execute permission to this script:
# chmod +x restore_backup.sh
####################################

# Specify which directory we are storing backups.
backup_dir="/home/ark-server/backups"
files_to_backup="/home/ark-server/arkserver/ShooterGame/Saved/ZelTheIslandMap"

# Check if a filename was provided
if [ -z "$1" ]; then
  echo "Usage: $0 <backup-filename>"
  echo "Example: $0 backup-2025-01-01.tar.gz"
  exit 1
fi

# Assign the filename passed as an argument
backup_filename="$1"

# Verify if the backup file exists
if [ ! -f "$backup_dir/$backup_filename" ]; then
  echo "Error: Backup file '$backup_dir/$backup_filename' does not exist."
  exit 1
fi

# Stop ARK Server
sudo systemctl stop ark

# Remove existing data
rm -rf $files_to_backup/*

# Restore the specified backup file
tar -xvf "$backup_dir/$backup_filename" -C /

# Restore permissions on files
chown ark-server:ark-server -R $files_to_backup

# Start ARK Server
sudo systemctl start ark

echo "Backup '$backup_filename' has been restored successfully."
