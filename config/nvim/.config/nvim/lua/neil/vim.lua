-- 全域變數與環境設定 (Globals)
vim.g.mapleader = " " -- 設定 Leader Key 為空白鍵
vim.g.encoding = "utf-8" -- 強制編碼 (Neovim 預設即為 utf-8)
-- 停用內建 netrw (為了相容 nvim-tree, oil.nvim)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- 顯示與視覺效果 (UI & Visuals)
vim.opt.number = true -- 顯示絕對行號
vim.opt.relativenumber = true -- 顯示相對行號
vim.opt.cursorline = true -- 高亮當前所在行
vim.opt.termguicolors = true -- 開啟 24-bit RGB 真彩色支援
vim.opt.signcolumn = "yes" -- 始終顯示左側狀態欄
vim.opt.colorcolumn = "80" -- 在第 80 字元處顯示垂直線
vim.opt.showmatch = true -- 輸入括號時閃爍對應括號
vim.opt.cmdheight = 1 -- 命令列高度
vim.opt.showmode = false -- 不顯示 -- INSERT
vim.opt.fillchars = { eob = " " } -- 隱藏檔案結尾處醜醜的波浪號 (~)

-- 搜尋行為 (Search)
vim.opt.hlsearch = true -- 高亮顯示搜尋結果
vim.opt.incsearch = true -- 輸入搜尋詞時即時預覽
vim.opt.ignorecase = true -- 搜尋時忽略大小寫
vim.opt.smartcase = true -- 若搜尋詞包含大寫，則轉為精確匹配

-- 縮排與排版 (Indentation & Layout)
vim.opt.tabstop = 4 -- Tab 顯示寬度
vim.opt.softtabstop = 4 -- 退格鍵刪除的空白數
vim.opt.shiftwidth = 4 -- 自動縮排的寬度
vim.opt.expandtab = false -- 將 Tab 轉換為空白鍵
vim.opt.smartindent = false -- 開啟智慧縮排
vim.opt.autoindent = true -- 延續上一行的縮排
vim.opt.wrap = false -- 關閉自動換行 (長代碼不折行)
vim.opt.iskeyword:append("-") -- 將 "-" 視為單字的一部分 (如 CSS class-name)

-- 操作手感與視窗管理 (Interaction & Window)
vim.opt.scrolloff = 10 -- 捲動時游標與邊界保持 10 行
vim.opt.sidescrolloff = 10 -- 左右捲動保持 10 字元
vim.opt.selection = "inclusive" -- 選取時包含最後一個字元
vim.opt.splitbelow = true -- 水平分割視窗在下方開啟
vim.opt.splitright = true -- 垂直分割視窗在右方開啟
vim.opt.mouse = "a" -- 啟用滑鼠支援
vim.opt.autochdir = false -- 不要自動切換工作目錄 (避免插件抓不到 root)

-- 命令列補全模式 (按 Tab 的行為)
vim.opt.wildmode = "longest:full,full"

-- 檔案處理與撤銷 (File Handling & Undo)
vim.opt.swapfile = false -- 不產生 .swp 暫存檔
vim.opt.backup = false -- 不產生備份檔
vim.opt.autoread = true -- 外部變動時自動重新讀取
vim.opt.autowrite = false -- 不自動存檔
-- 撤銷目錄設定 (持久化撤銷)
local undodir = vim.fn.expand("~/.local/state/undodir")
if vim.fn.isdirectory(undodir) == 0 then
	vim.fn.mkdir(undodir, "p")
end
vim.opt.undodir = undodir
vim.opt.undofile = true -- 開啟持久化撤銷

-- 效能優化 (Performance)
vim.opt.updatetime = 50 -- 加快回應速度 (影響 GitGutter/LSP)
vim.opt.lazyredraw = true -- 執行巨集時不重繪畫面
vim.opt.synmaxcol = 300 -- 限制語法高亮字元數
vim.opt.redrawtime = 10000 -- 增加畫面重繪容忍時間

-- 代碼折疊與補全 (Folding & PUM)
vim.opt.foldmethod = "indent" -- 根據縮排折疊
vim.opt.foldenable = false -- 開啟檔案時預設不折疊
-- 補全選單設定 (Popup Menu)
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.pumheight = 10 -- 選單最大高度
vim.opt.pumblend = 10 -- 選單透明度 (10%)
vim.opt.winblend = 0 -- 浮動視窗透明度

vim.lsp.log.set_level("error")
