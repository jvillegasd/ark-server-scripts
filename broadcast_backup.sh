#!/bin/bash
####################################
# Send a broadcast message to all players on the Ark server
# warning them of an imminent restart.
#
# PD: This script requires the Ark server to be running inside
# a screen session named "arkserver".
#
# Ensure this script has execution permissions:
# chmod +x broadcast_backup.sh
####################################

# Name of the screen session where the Ark server is running
screen_name="arkserver"

# message to broadcast
message="¡Atención! El servidor se reiniciará en contados minutos."

# Check if the screen session is active
if screen -list | grep -q "$screen_name"; then
  # Send the broadcast message to the Ark server console
  screen -S "$screen_name" -X stuff "broadcast $message\n"
  echo "message sent: $message"
else
  # Error message if the screen session is not found
  echo "Error: Screen session '$screen_name' not found. Is the server running?"
  exit 1
fi
