#!/bin/bash
####################################
# Send a broadcast message to all players on the Ark server
# warning them of an imminent restart using Rcon.
#
# PD: This script requires the rcon binary to be located
# in the "rcon-client" folder and properly configured.
#
# Ensure this script has execution permissions:
# chmod +x broadcast_backup.sh
#
# RCON client used: https://github.com/gorcon/rcon-cli, I downloaded the binary from the releases page.
####################################

# Path to the rcon client binary
rcon_client_path="/home/ark-server/rcon-client/rcon"

# RCON server configuration
rcon_host="127.0.0.1"       # Replace with your server's IP if not localhost
rcon_port="32330"           # RCON port configured in GameUserSettings.ini
rcon_password="your_password_here"  # Replace with your ServerAdminPassword

# Message to broadcast
message="¡Atención, supervivientes! El servidor se reiniciará en 10 minutos, pónganse en un lugar seguro y tomen foto de inventario."

# Check if the rcon binary exists
if [[ ! -x "$rcon_client_path" ]]; then
  echo "Error: Rcon binary not found or not executable at $rcon_client_path"
  exit 1
fi

# Send the broadcast message using rcon
$rcon_client_path -a $rcon_host:$rcon_port -p $rcon_password "broadcast $message"

# Check if the command was successful
if [[ $? -eq 0 ]]; then
  echo "Message sent: $message"
else
  echo "Error: Failed to send the message. Check your RCON configuration."
  exit 1
fi
