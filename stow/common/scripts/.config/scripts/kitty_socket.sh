#!/bin/bash

# 設定 socket 路徑
SOCKET_PATH="/tmp/kitty"

# 設定 kitty 執行檔路徑（可省略，若已加入 PATH）
KITTY_BIN="kitty"

# 檢查 socket 是否已存在且可用
if [ -S "$SOCKET_PATH" ]; then
    echo "🟢 Kitty socket 已存在於 $SOCKET_PATH"
    echo "✅ 不需重新啟動"
else
    # 檢查是否已經有 kitty 在執行
    if pgrep -x "kitty" >/dev/null; then
        echo "⚠️ Kitty 已經在執行，但未開啟 remote control socket。"
        echo "🧯 請手動關閉 kitty 並重新啟動，或確認 listen_on 是否正確設定。"
        exit 1
    fi

    # 等待 socket 成功建立
    echo -n "⌛ 等待 socket 建立中"
    for i in {1..10}; do
        if [ -S "$SOCKET_PATH" ]; then
            echo -e "\n✅ Socket 建立成功"
            break
        fi
        echo -n "."
        sleep 0.5
    done

    # 如果 socket 還沒建立成功，則退出
    if [ ! -S "$SOCKET_PATH" ]; then
        echo -e "\n❌ 建立失敗：$SOCKET_PATH 未建立"
        exit 2
    fi
fi
