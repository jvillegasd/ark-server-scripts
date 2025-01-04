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
backup_files="/home/ark-server/arkserver/ShooterGame/Saved/ZelTheIslandMap"
backup_file_name="the_island_backup"

# Specify which directory to backup to.
# Make sure you have enough space to hold 30 days of backups. This
# can be on the server itself, to an external hard drive or mounted network share.
# Warning: Ark worlds can get fairly large so choose your backup destination accordingly.
dest="/home/ark-server/backups"

# Create backup archive filename.
day=$(date +"%Y-%m-%d_%H-%M-%S")
archive_file="$day-$backup_file_name.tar.gz"

# Stop ARK Server
sudo systemctl stop ark

# Backup the files using tar.
tar zcvf $dest/$archive_file $backup_files

# Clear backups
/home/ark-server/manage/clear_backups.sh

# Start ARK Server
sudo systemctl start ark
