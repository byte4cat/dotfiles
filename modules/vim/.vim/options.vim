" 檔案類型與編碼 (Filetype & Encoding)
filetype plugin indent on   " 自動識別檔案類型，並載入對應的插件與縮排規則
syntax on                   " 開啟語法高亮

set encoding=utf-8          " Vim 內部處理字串的預設編碼
set fileencodings=utf-8,cp950 " 開啟檔案時的編碼嘗試順序（優先 UTF-8，其次繁體中文 Big5/CP950）
set clipboard=unnamedplus
set mouse=a


" 縮排與 Tab 控制 (Indentation & Tabs)
set autoindent              " 新行自動跟隨上一行的縮排格式
set smartindent             " 開啟智慧縮排（自動根據 C 語言風格的括號等調整縮排）
set tabstop=4               " 1 個 Tab 鍵在畫面上顯示為 4 個空白的寬度
set softtabstop=4           " 按下 Tab/Backspace 時，一次插入/刪除 4 個空白
set shiftwidth=4            " 自動縮排（如按 > 或 < 時）移動的空白數量為 4
set expandtab               " 將輸入的 Tab 自動轉換為半角空白字元（Space）


" 介面與顯示樣式 (UI & Visuals)
set number                  " 顯示絕對行號
set relativenumber          " 顯示相對行號（方便用 5j / 10k 等指令精準跳行）
set ruler                   " 在右下角顯示目前的列號、欄號與游標位置
set background=dark         " 設定背景模式為深色，供主題/語法顏色選擇合適配色
set signcolumn=yes          " 永遠顯示左側的標記欄（防止 Git 提示或 LSP 報錯符號跳出時畫面擠壓）
set cursorline              " 高亮顯示目前的游標所在行
set colorcolumn=80          " 在第 80 個字元處顯示一條垂直邊界線（提醒程式碼長度）
set nowrap                  " 當單行文字過長時不自動換行
set showmatch               " 當游標移到括號時，短暫高亮顯示對應的另一半括號
set laststatus=2            " 永遠顯示底部的狀態列（Statusline）
set scrolloff=10            " 畫面上下捲動時，游標上方與下方至少保留 10 行空間


" 搜尋行為設定 (Search Configuration)
set hlsearch                " 高亮顯示所有搜尋到的匹配結果
set incsearch               " 邊輸入搜尋關鍵字，邊即時跳轉並高亮匹配內容
set ignorecase              " 搜尋時預設忽略大小寫
set smartcase               " 如果搜尋關鍵字包含大寫字母，則自動切換回敏感大小寫搜尋


" 視窗分割與編輯行為 (Window Splits & Editing Behavior)
set splitbelow              " 新的水平分割視窗（:sp）會開在當前視窗的「下方」
set splitright              " 新的垂直分割視窗（:vs）會開在當前視窗的「右方」
set backspace=indent,eol,start " 讓 Backspace 鍵可以正常刪除縮排、換行符號與進入 Insert 模式前的字

" 將減號 - 視為單字的一部分（讓 dw/diw/ciw 可以把 user-controller 當成單一單字處理）
set iskeyword+=-


" 程式碼折疊 (Code Folding)
set foldmethod=indent       " 根據程式碼的縮排（Indent）自動建立折疊區塊
set nofoldenable            " 剛打開檔案時預設展開所有折疊，不自動收合程式碼


" 系統效能與互動 (System & Performance)
set updatetime=50           " 將觸發 CursorHold 事件的延遲改為 50ms（讓 LSP/GitSigns 提示反應極快）
set confirm                 " 關閉未儲存檔案等衝突操作時，彈出對話框明確詢問（不用強加 !）
set history=200             " 保留最近使用過的 200 條命令行指令歷史紀錄
