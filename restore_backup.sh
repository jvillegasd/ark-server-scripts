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

# Stop ARK Server
sudo systemctl stop ark

# Remove existing data
rm -rf $files_to_backup/*

# Restore a saved file.
tar -xvf $backup_dir/FILENAME.tar.gz -C /

# Restore permissions on files
chown ark-server:ark-server -R $files_to_backup

# Start ARK Server
sudo systemctl start ark
