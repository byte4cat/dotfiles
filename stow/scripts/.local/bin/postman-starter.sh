#!/bin/bash

# 這是終端機中證明有效的命令。
# 使用 'exec' 可以替換當前的 shell 進程，減少資源消耗。
exec /opt/postman/app/postman --enable-features=UseOzonePlatform --ozone-platform-hint=auto --disable-gpu "$@"
