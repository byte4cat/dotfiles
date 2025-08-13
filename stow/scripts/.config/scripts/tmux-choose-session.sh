#!/usr/bin/env bash

session=$(tmux list-sessions -F "#{session_name}" | fzf)

selected=$session

if [[ -z $selected ]]; then
    exit 0
fi

# echo "Attaching to session: $selected"

tmux attach-session -t "$selected"
