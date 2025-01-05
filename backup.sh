#!/bin/bash
####################################
# Backup Ark server to a
# specified folder.
#
# PD: This script use 'sudo' to stop and start the ark server service, so you
# need to add the following line to the sudoers file (sudo visudo):
# <username_who_runs_this_script> ALL=(ALL) NOPASSWD: /bin/systemctl stop ark, /bin/systemctl start ark
#
# Give execute permission to this script:
# chmod +x backup.sh
####################################

# Variables
screen_name="arkserver"
map_name="TheIsland"  # Name of the map to backup
files_to_backup="/home/ark-server/arkserver/ShooterGame/Saved/Zel${map_name}Map"
backup_file_name="${map_name}_backup"
backup_dir="/home/ark-server/backups"
clear_backups_script="/home/ark-server/manage/clear_backups.sh"

# Verify backup source
if [ ! -d "$files_to_backup" ]; then
  echo "Error: Backup files directory $files_to_backup does not exist."
  exit 1
fi

# Create backup directory if it doesn't exist
if [ ! -d "$backup_dir" ]; then
  echo "The directory $backup_dir does not exist. Creating it..."
  mkdir -p "$backup_dir" || { echo "Error: Failed to create $backup_dir."; exit 1; }
fi

# Create backup archive filename.
day=$(date +"%Y-%m-%d_%H-%M-%S")
archive_file="$day-$backup_file_name.tar.gz"

# Forcing save on Ark server
echo "Forcing save on Ark server..."
screen -S "$screen_name" -X stuff "saveworld\n" || { echo "Error: Failed to send saveworld command."; exit 1; }
sleep 20  # Give the server time to complete the save. It takes about 10-15 seconds to save world.

# Stop ARK Server
echo "Stopping Ark server..."
sudo systemctl stop ark || { echo "Error: Failed to stop the Ark server."; exit 1; }

# Backup only necessary files using tar
echo "Creating backup archive..."
cd "$files_to_backup" || { echo "Error: Failed to access $files_to_backup."; exit 1; }

tar zcvf $backup_dir/$archive_file \
  ${map_name}.ark \
  ${map_name}_NewLaunchBackup.bak \
  ${map_name}_AntiCorruptionBackup.bak \
  *.arkprofile \
  *.arktribe \
  $(ls ${map_name}_*.ark | sort | tail -n 1) || { echo "Error: Failed to create backup archive."; exit 1; }

# Run cleanup script if it exists
if [ -f "$clear_backups_script" ]; then
  echo "Running backup cleanup script..."
  "$clear_backups_script" || { echo "Error: Cleanup script failed."; exit 1; }
else
  echo "Warning: Cleanup script $clear_backups_script not found. Skipping cleanup."
fi

# Start ARK Server
sudo systemctl start ark || { echo "Error: Failed to start the Ark server."; exit 1; }

# Confirm completion
echo "Backup completed successfully. File saved at: $backup_dir/$archive_file"
