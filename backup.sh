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

# What to backup.
files_to_backup="/home/ark-server/arkserver/ShooterGame/Saved/ZelTheIslandMap"
backup_file_name="the_island_backup"

# Verifies that the backup files directory exists.
if [ ! -d $files_to_backup ]; then
  echo "Backup files directory $files_to_backup does not exist."
  exit 1
fi

# Specify which directory to backup to.
# Make sure you have enough space to hold +7 days of backups. This
# can be on the server itself, to an external hard drive or mounted network share.
# Warning: Ark worlds can get fairly large so choose your backup destination accordingly.
backup_dir="/home/ark-server/backups"

# Check if the directory exists, if not, create it
if [ ! -d "$backup_dir" ]; then
    echo "The directory $backup_dir does not exist. Creating it..."
    mkdir -p "$backup_dir"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to create the directory $backup_dir."
        exit 1
    fi
    echo "Directory created successfully."
fi

# Create backup archive filename.
day=$(date +"%Y-%m-%d_%H-%M-%S")
archive_file="$day-$backup_file_name.tar.gz"

# Stop ARK Server
sudo systemctl stop ark

# Backup the files using tar.
tar zcvf $backup_dir/$archive_file $files_to_backup

# Clear backups
/home/ark-server/manage/clear_backups.sh

# Start ARK Server
sudo systemctl start ark
