#!/bin/bash

set -euo pipefail

base_wallpaper_directory="$HOME/.config/wallpapers/"

# check if the base wallpaper directory exists
if [ ! -d "$base_wallpaper_directory" ]; then
    echo "Base wallpaper directory does not exist: $base_wallpaper_directory"
    exit 1
fi

wallpaper_directories=()
# Read the directories in the base wallpaper directory
# This will allow us to use fzf to select a directory
while IFS= read -r -d '' dir; do
    wallpaper_directories+=("$dir")
done < <(find "$base_wallpaper_directory" -mindepth 1 -maxdepth 1 -type d -print0)

if [[ ${#wallpaper_directories[@]} -eq 0 ]]; then
    echo "No wallpaper directories found in $base_wallpaper_directory"
    exit 1
fi

for i in "${!wallpaper_directories[@]}"; do
    # Remove the base wallpaper directory prefix for display
    wallpaper_directories[$i]="${wallpaper_directories[$i]#$base_wallpaper_directory/}"
done

# Find all directories in the base wallpaper directory and use fzf to select one
selected_dir=$(
    printf "%s\n" "${wallpaper_directories[@]}" | fzf --prompt="Select wallpaper directory: "
)

if [[ -z $selected_dir ]]; then
    echo "No directory selected"
    exit 0
fi

if [ -n "$TMUX" ]; then
    # 在 tmux 中使用 viu
    preview_cmd='viu -w 80 {}'
else
    # 在非 tmux 中使用 kitty icat
    preview_cmd='kitty +kitten icat --clear --transfer-mode=memory --place 80x40@140x5 --stdin < {} > /dev/tty'
fi

selected_image=$(
    find "$base_wallpaper_directory$selected_dir" -mindepth 1 -maxdepth 1 -type f \
        \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.bmp" \) \
        -not -name '.DS_Store' |
        fzf --preview "$preview_cmd" \
            --preview-window=right:50%:wrap \
            --prompt="Select wallpaper image: "
)

if [[ -z $selected_image ]]; then
    echo "No image selected"
    exit 0
fi

BACKGROUND_IMAGE="$selected_image"

if [ ! -f "$BACKGROUND_IMAGE" ]; then
    echo "The selected file does not exist"
    exit 1
fi

echo "Setting background image to $BACKGROUND_IMAGE"
kitty @ set-background-image "$BACKGROUND_IMAGE" >/dev/null 2>&1 &
