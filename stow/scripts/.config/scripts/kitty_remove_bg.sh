#!/bin/bash

kitty @ set-background-image none
ps aux | grep 'scripts/kitty_bg_rand.sh' | grep -v grep | awk '{print $2}' | xargs kill
pgrep -fl 'bash -c.*WALLPAPERS' | grep -Eo '^[0-9]+' | xargs kill
