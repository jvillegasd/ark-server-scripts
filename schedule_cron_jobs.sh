#!/bin/bash
####################################
# Schedule backup and broadcast scripts in cron.
#
# - Removes existing cron jobs for the scripts if they exist.
# - Schedules `broadcast_backup.sh` at 11:50 PM.
# - Schedules `backup.sh` at 12:00 AM.
#
# Prerequisites:
# - Ensure both scripts have execute permissions:
#   chmod +x backup.sh broadcast_backup.sh
#
# Execution:
#   Run this script with sufficient privileges to edit crontab:
#   ./schedule_cron_jobs.sh
####################################

# Paths to the scripts
broadcast_script="/home/ark-server/manage/broadcast_backup.sh"
backup_script="/home/ark-server/manage/backup.sh"

# Validate the broadcast script path
if [ ! -f "$broadcast_script" ]; then
  echo "Error: Broadcast script not found at $broadcast_script"
  exit 1
fi

# Validate the backup script path
if [ ! -f "$backup_script" ]; then
  echo "Error: Backup script not found at $backup_script"
  exit 1
fi

# Backup the current crontab
crontab -l > current_cron.bak 2>/dev/null
echo "Backup of current crontab saved to current_cron.bak"

# Remove existing jobs for the scripts
NEW_CRON=$(crontab -l 2>/dev/null | grep -v "$broadcast_script" | grep -v "$backup_script")

# Add the new jobs
NEW_CRON=$(echo "$NEW_CRON"; echo "50 23 * * * $broadcast_script")
NEW_CRON=$(echo "$NEW_CRON"; echo "0 0 * * * $backup_script")

# Apply the new crontab
echo "$NEW_CRON" | crontab -

# Confirm changes
if [ $? -eq 0 ]; then
  echo "Cron jobs successfully updated:"
  echo "  - Removed any existing jobs for the scripts."
  echo "  - Broadcast script scheduled at 11:50 PM."
  echo "  - Backup script scheduled at 12:00 AM."
else
  echo "Error: Failed to update cron jobs."
  exit 1
fi
