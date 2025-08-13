#!/bin/bash

# QUERY=$(wofi --dmenu --width 600 -L 1 -p "Search the web:")
# if [ -n "$QUERY" ]; then
#     xdg-open "https://www.google.com/search?q=$QUERY"
# fi

# HISTFILE="$HOME/.config/wofi/web_search_history"
# touch "$HISTFILE"
# QUERY=$(cat "$HISTFILE" | sort | uniq | tail -n 20 | wofi --dmenu -width 600 -lines 10 -p "Search the web:")
# if [ -n "$QUERY" ]; then
#     echo "$QUERY" >>"$HISTFILE"
#     xdg-open "https://www.google.com/search?q=$QUERY"
# fi

# # 取得使用者輸入
# QUERY=$(wofi --dmenu -p "Google Search:" -width 600 -lines 10)
# if [[ -z "$QUERY" ]]; then
#     exit 0
# fi
#
# # 呼叫 Google Suggest API
# SUGGESTIONS=$(curl -s "https://suggestqueries.google.com/complete/search?client=firefox&q=${QUERY}" | jq -r '.[1][]')
#
# # 如果有建議，顯示建議再選一次
# if [[ -n "$SUGGESTIONS" ]]; then
#     CHOICE=$(echo "$SUGGESTIONS" | wofi --dmenu -p "Choose suggestion:" -width 600 -lines 10)
# else
#     CHOICE="$QUERY"
# fi
#
# if [[ -n "$CHOICE" ]]; then
#     xdg-open "https://www.google.com/search?q=$CHOICE"
# fi

# 取得 wofi 輸入
INPUT=$(wofi --dmenu -p "Search the web:" --width 600 --lines 10 --columns 1)
[[ -z "$INPUT" ]] && exit 0

# 網址/Domain 偵測 regex
is_url() {
    [[ "$1" =~ ^https?:// ]] && return 0
    [[ "$1" =~ ^www\. ]] && return 0
    [[ "$1" =~ ^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(/.*)?$ ]] && return 0
    return 1
}

if is_url "$INPUT"; then
    # 網址直接跳轉
    [[ "$INPUT" =~ ^https?:// ]] && xdg-open "$INPUT" && exit 0
    xdg-open "http://$INPUT" && exit 0
fi

if [[ "$INPUT" =~ ^s\  ]]; then
    # s 空白開頭，去 Google Suggest
    KEYWORD="${INPUT:2}"
    SUGGESTIONS=$(curl -s "https://suggestqueries.google.com/complete/search?client=firefox&q=${KEYWORD}" | jq -r '.[1][]')
    # 沒有建議則 fallback
    if [[ -z "$SUGGESTIONS" ]]; then
        xdg-open "https://www.google.com/search?q=${KEYWORD}" && exit 0
    fi
    # 用 wofi 選建議
    CHOICE=$(echo "$SUGGESTIONS" | wofi --dmenu -p "選擇建議" -width 600 -lines 10)
    [[ -n "$CHOICE" ]] && xdg-open "https://www.google.com/search?q=${CHOICE}" && exit 0
    exit 0
fi

# 其他情況：直接 google 搜尋
xdg-open "https://www.google.com/search?q=${INPUT}"
