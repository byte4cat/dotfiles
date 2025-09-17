#!/bin/bash

USER_NAME="neil"
USER_HOME="/home/$USER_NAME"
LOG_PATH="$USER_HOME/.config/scripts/logs/fix_sleep_errors.log"

echo "Restarting NetworkManager and PipeWire after suspend... $(date)" >>"$LOG_PATH"
systemctl restart NetworkManager
USER_ID=$(id -u "$USER_NAME")
# 用 sudo -u 指定 user 跑 user session 的 pipewire
sudo -u "$USER_NAME" XDG_RUNTIME_DIR="/run/user/$USER_ID" systemctl --user restart pipewire pipewire-pulse >>"$LOG_PATH" 2>&1

#
# case $1 in
#     pre)
#         # 在休眠前執行的指令（可選）
#         ;;
#     post)
#         # 在休眠後執行的指令
#         echo "Restarting NetworkManager and PipeWire after suspend..." >> /var/log/fix_wifi_audio.log
#         sudo systemctl restart NetworkManager
#         systemctl --user restart pipewire pipewire-pulse
#         ;;
# esac
