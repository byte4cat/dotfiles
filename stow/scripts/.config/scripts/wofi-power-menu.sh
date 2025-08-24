#!/usr/bin/env bash

# options
options="🟢 Logout
⏻ Shutdown
🔄 Reboot
💤 Sleep
🔒 Lock
❌ Cancel"

selection=$(echo "$options" | wofi --dmenu --insensitive --lines=6 --prompt "Select an action" | cut -d' ' -f2)

case "$selection" in
"Logout")
    # Use the correct command for your session manager
    hyprctl dispatch exit
    ;;
"Shutdown")
    systemctl poweroff
    ;;
"Reboot")
    systemctl reboot
    ;;
"Sleep")
    systemctl suspend
    ;;
"Lock")
    hyprlock
    ;;
*)
    exit 0
    ;;
esac
