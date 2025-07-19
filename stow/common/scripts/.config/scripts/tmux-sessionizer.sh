#!/usr/bin/env bash

# === Config ===
SEARCH_DIRS=(
    "${HOME}/Development/personal"
    "${HOME}/Development/working/backend"
    "${HOME}/Development/working/app"
    "${HOME}/Development/working/cli"
    "${HOME}/Development/working/web"
    "${HOME}/Development/working/others"
    "${HOME}/Development/devops/itracxing"
    "${HOME}/Development/devops/tools"
    "${HOME}/Development/side_projects"
    "${HOME}/Development/learning/rust"
)

SESSIONIZER_LOG="${HOME}/scripts/tmux-sessionizer.log"

# remove old log file
if [[ -f "$SESSIONIZER_LOG" ]]; then
    rm -f "$SESSIONIZER_LOG"
fi

log() {
    echo "$(date +'%F %T') - $*" | tee -a "$SESSIONIZER_LOG"
}

# === FZF-based project picker ===
pick_project() {
    local selected
    selected=$(
        find "${SEARCH_DIRS[@]}" -mindepth 1 -maxdepth 1 -type d 2>/dev/null |
            sort |
            fzf --height=40% --reverse --prompt="📁 Pick a project > " \
                --preview 'tree -L 1 {} | head -100' \
                --preview-window=right:50%
    )

    [[ -z "$selected" ]] && exit 1
    echo "$selected"
}

# === Main logic ===
PROJECT_DIR="$1"
if [[ -z "$PROJECT_DIR" ]]; then
    # log "Launching fzf to pick a project..."
    PROJECT_DIR=$(pick_project)
fi

PROJECT_NAME="$(basename "$PROJECT_DIR")"
# log "Selected project: $PROJECT_NAME at $PROJECT_DIR"

# Check if session exists
if tmux has-session -t="$PROJECT_NAME" 2>/dev/null; then
    # log "Session $PROJECT_NAME already exists."
    if [[ -n "$TMUX" ]]; then
        # log "Inside tmux, switching client..."
        tmux switch-client -t "$PROJECT_NAME" || {
            # log "[warn] switch-client failed, creating new window..."
            tmux new-window -t "$PROJECT_NAME" -c "$PROJECT_DIR"
        }
    else
        # log "Outside tmux, attaching..."
        tmux attach-session -t "$PROJECT_NAME"
    fi
    exit 0
fi

# Create session
# log "Creating session $PROJECT_NAME..."
tmux new-session -d -s "$PROJECT_NAME" -c "$PROJECT_DIR"

# Wait a bit to catch any immediate exit
sleep 0.2
if ! tmux has-session -t="$PROJECT_NAME" 2>/dev/null; then
    # log "[fatal] Session vanished. Shell likely exited immediately."
    # log "[hint] Check shell rc files (.zshrc/.bashrc) for early exits."
    exit 1
fi

# Switch or attach
if [[ -n "$TMUX" ]]; then
    # log "Inside tmux, switching..."
    tmux switch-client -t "$PROJECT_NAME"
else
    # log "Outside tmux, attaching..."
    tmux attach-session -t "$PROJECT_NAME"
fi
