#!/bin/bash

USER_NAME="neil"
USER_HOME="/home/$USER_NAME"
LOG_PATH="$USER_HOME/.config/scripts/logs/restart_pipewire.log"

echo "Restarting PipeWire... $(date)" >>"$LOG_PATH"
USER_ID=$(id -u "$USER_NAME")

# 用 sudo -u 指定 user 跑 user session 的 pipewire
# restart pipewire, pipewire-pulse and xdg-desktop-portal
sudo -u "$USER_NAME" XDG_RUNTIME_DIR="/run/user/$USER_ID" systemctl --user restart pipewire pipewire-pulse xdg-desktop-portal >>"$LOG_PATH" 2>&1
