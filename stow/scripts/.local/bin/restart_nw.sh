#!/bin/bash

USER_NAME="neil"
USER_HOME="/home/$USER_NAME"
LOG_PATH="$HOME/.local/share/bin/logs/restart_nw.log"

echo "Restarting NetworkManager... $(date)" >>"$LOG_PATH"
sudo systemctl restart NetworkManager
