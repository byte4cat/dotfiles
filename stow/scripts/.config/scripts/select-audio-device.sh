#!/usr/bin/env bash

set -e

for cmd in wpctl wofi; do
    command -v $cmd >/dev/null 2>&1 || {
        echo "Missing $cmd"
        exit 1
    }
done

MODE=$(printf "Output\nInput" | wofi --dmenu --lines=2 --prompt="Select device type")
[ -z "$MODE" ] && exit 0

if [[ "$MODE" == "Output" ]]; then
    SECTION="Sinks"
    PROMPT="Select Output Device"
elif [[ "$MODE" == "Input" ]]; then
    SECTION="Sources"
    PROMPT="Select Input Device"
else
    exit 0
fi

# Parsing logic matches your actual format!
DEVICES=$(awk -v section="$SECTION" '
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

[ -z "$DEVICES" ] && {
    notify-send "No devices found!"
    exit 1
}

SELECTED_LINE=$(printf "%s\n" "$DEVICES" | wofi --dmenu --prompt="$PROMPT")
[ -z "$SELECTED_LINE" ] && exit 0

SELECTED=$(echo "$SELECTED_LINE" | sed 's/^[★ ]*//' | cut -d'|' -f1 | awk '{print $1}')

wpctl set-default "$SELECTED"
notify-send "Audio device switched" "$MODE set to: $(echo "$SELECTED_LINE" | cut -d'|' -f2- | xargs)"
