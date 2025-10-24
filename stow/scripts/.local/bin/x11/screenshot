#!/usr/bin/env bash

# --- 配置 ---
SAVE_DIR="$SCREENSHOT_DIR"
LOG_FILE="$HOME/.local/bin/logs/screenshot.log"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
# ---

# --- Log Function ---
log_message() {
    local message="$1"
    mkdir -p "$LOG_DIR"
    echo "$(date '+%Y-%m-%d %H:%M:%S') [INFO] $message" >>"$LOG_FILE"
}

# --- Check ---
# check scrot and xclip are installed
command -v scrot >/dev/null 2>&1 || {
    echo "Error: scrot not found."
    log_message "ERROR: scrot not found, exiting."
    exit 1
}
command -v notify-send >/dev/null 2>&1 || { echo "Warning: notify-send not found."; }

# create folder if not exits
mkdir -p "$SAVE_DIR"

MODE="$1" # mode: region, window, full, save-region, save-window, save-full
SUMMARY="📸 Screenshot"

# --- 核心截圖邏輯 ---
take_screenshot() {
    local scrot_options="$1" # -s, -u, or none
    local action="$2"        # 'copy' or 'save'
    local type="$3"          # region, window, or full
    local log_msg=""
    local success=0 # 0 for success, 1 for failure

    if [[ "$action" == "copy" ]]; then
        # 複製到剪貼簿模式
        if ! command -v xclip >/dev/null 2>&1; then
            notify-send "$SUMMARY" "Error: xclip not found for copy action."
            log_message "ERROR: xclip not found for copy action."
            return 1
        fi

        # 使用 -e 參數，將截圖輸出到 xclip 並刪除臨時文件
        if scrot "$scrot_options" -e "xclip -selection clipboard -t image/png -i \$f && rm \$f"; then
            BODY="${type} screenshot copied to clipboard"
            log_msg="Action: COPY | Type: ${type} | Status: SUCCESS | Destination: Clipboard"
            success=0
        else
            BODY="Failed to take ${type} screenshot."
            log_msg="Action: COPY | Type: ${type} | Status: FAILURE"
            success=1
        fi

    elif [[ "$action" == "save" ]]; then
        # 儲存到文件模式
        FILENAME="$SAVE_DIR/${type}-${TIMESTAMP}.png"

        # 截圖並直接儲存到文件
        if scrot "$scrot_options" "$FILENAME"; then
            BODY="${type} screenshot saved to $FILENAME"
            log_msg="Action: SAVE | Type: ${type} | Status: SUCCESS | Destination: $FILENAME"
            success=0
        else
            BODY="Failed to take ${type} screenshot."
            log_msg="Action: SAVE | Type: ${type} | Status: FAILURE"
            success=1
        fi
    fi

    # 發送通知
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "$SUMMARY" "$BODY"
    fi

    # 記錄日誌
    log_message "$log_msg"
    return "$success"
}

# --- 模式解析 ---
case "$MODE" in
region)
    take_screenshot "-s" "copy" "region"
    ;;
window)
    take_screenshot "-u" "copy" "window"
    ;;
full)
    take_screenshot "" "copy" "full"
    ;;
save-region)
    take_screenshot "-s" "save" "region"
    ;;
save-window)
    take_screenshot "-u" "save" "window"
    ;;
save-full)
    take_screenshot "" "save" "full"
    ;;
*)
    log_message "ERROR: Invalid argument provided: $MODE"
    echo "Usage: $0 {region|window|full|save-region|save-window|save-full}"
    exit 1
    ;;
esac

exit 0
