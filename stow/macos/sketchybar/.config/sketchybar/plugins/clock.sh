#!/usr/bin/env sh
source "$HOME/.config/sketchybar/icons.sh"

ICON="$ICON_CLOCK"
LABEL=$(date '+%H:%M:%S')
LABEL_UTC=$(date -u '+%H:%M:%S')
sketchybar --set $NAME icon="$ICON" label="CST $LABEL | UTC $LABEL_UTC"

