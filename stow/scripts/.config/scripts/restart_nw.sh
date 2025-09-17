#!/bin/bash

USER_NAME="neil"
USER_HOME="/home/$USER_NAME"
LOG_PATH="$USER_HOME/.config/scripts/logs/restart_nw.log"

echo "Restarting NetworkManager... $(date)" >>"$LOG_PATH"
sudo systemctl restart NetworkManager
