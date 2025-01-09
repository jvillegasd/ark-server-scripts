#!/bin/bash
####################################
# List players currently connected to the Ark server using RCON.
#
# RCON client used: https://github.com/gorcon/rcon-cli
#
# Requirements:
# - RCON must be enabled on the Ark server.
# - The gorcon RCON client binary must be downloaded and available.
#
# Usage:
# chmod +x list_players.sh
# ./list_players.sh
####################################

# Variables
rcon_client_path="/home/ark-server/rcon-client/rcon"
rcon_host="127.0.0.1"       # Replace with your server's IP if not localhost
rcon_port="32330"           # RCON port configured in GameUserSettings.ini
rcon_password="your_password_here"  # Replace with your ServerAdminPassword

# RCON command to list players
rcon_command="listplayers"

# Verify RCON client binary
if [ ! -f "$rcon_client_path" ]; then
  echo "Error: RCON client not found at $rcon_client_path."
  exit 1
fi

# Execute the RCON command to list players
echo "Fetching list of connected players from the Ark server..."
$rcon_client_path -a "$rcon_host:$rcon_port" -p "$rcon_password" "$rcon_command"

# Check if the command was successful
if [ $? -ne 0 ]; then
  echo "Error: Failed to execute listplayers command via RCON."
  exit 1
fi

# Confirm completion
echo "Player list fetched successfully."
