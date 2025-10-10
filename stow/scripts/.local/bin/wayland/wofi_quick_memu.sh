#!/usr/bin/env bash

set -e

SCRIPTS_DIR="$HOME/.local/bin"
LOG_PATH="$SCRIPTS_DIR/logs/wofi_quick_memu.log"

OPTIONS=(
    "Audio Output"
    "Audio Input"
    "Restart PipeWire"
    "Restart NetworkManager"
    "Restart Wifi wlan0"
)

logger() {
    mkdir -p "$(dirname "$LOG_PATH")"
    echo "$(date): $*" >>"$LOG_PATH"
}

for cmd in wpctl wofi; do
    command -v $cmd >/dev/null 2>&1 || {
        echo "Missing $cmd"
        logger "Missing dependency: $cmd"
        notify-send "Missing dependency: $cmd"
        exit 1
    }
done

select_audio_device() {
    logger "Selected mode: $1"
    local section prompt devices selected_line selected
    if [[ "$1" == "Audio Output" ]]; then
        logger "Setting section to Sinks"
        section="Sinks"
        prompt="Select Audio Output Device"
    elif [[ "$1" == "Audio Input" ]]; then
        logger "Setting section to Sources"
        section="Sources"
        prompt="Select Audio Input Device"
    else
        notify-send "Unknown audio type: $1"
        exit 1
    fi

    # Parsing logic matches your actual format!
    devices=$(awk -v section="$section" '
        $0 ~ "^[[:space:]]*├─ "section":" { in_section=1; next }
        in_section && $0 ~ "^[[:space:]]*│" && $0 ~ /\[vol:/ {
            line=$0; sub(/^[ \t]*│[ \t]*/,"",line)
            is_default = match(line, /^\* +([0-9]+)\.\s+(.+)$/, parts)
            if (is_default) {
                id = parts[1]
                name = parts[2]
                printf "★ %s | %s\n", id, name
            } else if (match(line, /^([0-9]+)\.\s+(.+)$/, parts)) {
                id = parts[1]
                name = parts[2]
                printf "  %s | %s\n", id, name
            }
            next
        }
        in_section && $0 !~ "^[[:space:]]*│" { in_section=0 }
    ' < <(wpctl status))

    [ -z "$devices" ] && {
        notify-send "No devices found!"
        exit 1
    }

    selected_line=$(printf "%s\n" "$devices" | wofi --dmenu --prompt="$prompt")
    [ -z "$selected_line" ] && exit 0

    selected=$(echo "$selected_line" | sed 's/^[★ ]*//' | cut -d'|' -f1 | awk '{print $1}')

    logger "User selected device ID: $selected"

    wpctl set-default "$selected"
    notify-send "Audio device switched" "$1 set to: $(echo "$selected_line" | cut -d'|' -f2- | xargs)"
}

main() {
    logger "Script started"

    selection=$(printf "%s\n" "${OPTIONS[@]}" | wofi --dmenu --lines=$((${#OPTIONS[@]} + 1)) --prompt="Select device type")
    [ -z "$selection" ] && exit 0

    logger "User selected: $selection"

    case "$selection" in
    "Audio Output" | "Audio Input")
        logger "Proceeding to select $selection device"
        select_audio_device "$selection"
        exit 0
        ;;
    "Restart PipeWire")
        logger "Restarting PipeWire"
        notify-send "Restarting PipeWire"
        "$SCRIPTS_DIR/restart_pipewire.sh"
        exit 0
        ;;
    "Restart NetworkManager")
        logger "Restarting NetworkManager"
        notify-send "Restarting NetworkManager"
        "$SCRIPTS_DIR/restart_nw.sh"
        exit 0
        ;;
    "Restart Wifi wlan0")
        logger "Restarting Wifi wlan0"
        notify-send "Restarting Wifi wlan0"
        "$SCRIPTS_DIR/restart_wifi_wlan0.sh"
        exit 0
        ;;
    *)
        logger "Unknown option selected: $selection"
        notify-send "Unknown Selection" "The selected option '$selection' is not yet implemented."
        exit 0
        ;;
    esac
}

main
