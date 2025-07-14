#!/bin/bash

# gomodifytags  修改結構體的標籤
# go-callvis  生成調用圖
# json-to-go  將 JSON 轉換為 Go 結構體
# gofumpt  格式化 Go 代碼
# ginkgo  BDD 測試框架
# mockgen  生成 mock 類型
# fillswitch  自動填充 switch 語句
# impl  根據接口生成方法實現
# go-enum  生成枚舉類型
# govulncheck  檢查依賴中的已知漏洞
# json-to-struct
# golines  自動斷行長行
# gomvp  重構工具
# iferr  快速插入錯誤處理
# gotests  根據函數生成測試代碼
# gonew  根據模板創建新模塊
# richgo  彩色化測試輸出
# dlv  Go 調試器
# gopls  Go 語言服務器
# golangci-lint  多合一的 Go 靜態分析工具
# goimports  自動添加/刪除 import
# gotestsum  增強的測試輸出工具

# Go 工具安裝腳本
# 安裝 gomodifytags
go install github.com/fatih/gomodifytags@latest

# 安裝 callgraph
go install github.com/ofabry/go-callvis@latest

# 安裝 json-to-struct
go install github.com/mholt/json-to-go@latest

# 安裝 gofumpt
go install mvdan.cc/gofumpt@latest

# 安裝 ginkgo
go install github.com/onsi/ginkgo/v2/ginkgo@latest

# 安裝 mockgen
go install github.com/golang/mock/mockgen@latest

# 安裝 fillswitch
go install github.com/ryan-berger/fillswitch@latest

# 安裝 impl
go install github.com/josharian/impl@latest

# 安裝 go-enum
go install github.com/abice/go-enum@latest

# 安裝 govulncheck
go install golang.org/x/vuln/cmd/govulncheck@latest

# 安裝 gojsonstruct
go install github.com/tmc/json-to-struct@latest

# 安裝 golines
go install github.com/segmentio/golines@latest

# 安裝 gomvp
go install github.com/dstotijn/gomvp@latest

# 安裝 iferr
go install github.com/koron/iferr@latest

# 安裝 gotests
go install github.com/cweill/gotests/...@latest

# 安裝 gonew
go install golang.org/x/tools/cmd/gonew@latest

# 安裝 richgo
go install github.com/kyoh86/richgo@latest
