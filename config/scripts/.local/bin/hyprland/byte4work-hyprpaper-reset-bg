#!/bin/bash
CONFIG="$HOME/.config/hypr/hyprpaper.conf"

grep '^wallpaper' "$CONFIG" | while IFS=',' read -r left right; do
    # remove "wallpaper = " and trim spaces
    monitor=$(echo "$left" | sed 's/wallpaper = //;s/ *$//')
    image=$(echo "$right" | xargs)
    echo "Setting wallpaper for $monitor to $image"
    hyprctl hyprpaper wallpaper "$monitor,$image"
done
