#!/bin/bash
####################################
# Clean up ARK saved game to a
# specified folder.
#
# Give execute permission to this script:
# chmod +x clear_backups.sh
####################################

# -mtime +30 means any file older than 30 days
find /home/ark-server/backups -type f -mtime +30 -exec rm -f {} \;
