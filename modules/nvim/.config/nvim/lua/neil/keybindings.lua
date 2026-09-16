-- ==========================================================================
-- 基礎模式與包圍文字功能
-- ==========================================================================

vim.api.nvim_set_keymap("i", "jk", "<Esc>", { noremap = true, silent = true, desc = "Exit Insert Mode" })

local function wrap_visual(open_sym, close_sym)
	local mode = vim.fn.mode()

	if mode == "V" then
		-- 整行選取
		return string.format([[c%s<CR><C-r>"%s<ESC>='[]], open_sym, close_sym)
	elseif mode == "\22" or mode == "\16" then
		-- 區塊選取
		return string.format([[I%s<ESC>gvA%s<ESC>]], open_sym, close_sym)
	else
		-- 局部選取
		return string.format([[c%s<C-r>"%s<ESC>]], open_sym, close_sym)
	end
end

vim.keymap.set("v", "(", function()
	return wrap_visual("(", ")")
end, { expr = true })
vim.keymap.set("v", "[", function()
	return wrap_visual("[", "]")
end, { expr = true })
vim.keymap.set("v", "{", function()
	return wrap_visual("{", "}")
end, { expr = true })
vim.keymap.set("v", '"', function()
	return wrap_visual('"', '"')
end, { expr = true })
vim.keymap.set("v", "'", function()
	return wrap_visual("'", "'")
end, { expr = true })
vim.keymap.set("v", "`", function()
	return wrap_visual("`", "`")
end, { expr = true })

-- ==========================================================================
-- 視窗與分割管理
-- ==========================================================================

-- 使用 <F3> 交換當前視窗和下一個視窗的位置
vim.api.nvim_set_keymap("n", "<F3>", "<C-w>x", { noremap = true, silent = true, desc = "Swap Window Position" })

-- 使用 <leader> + h/j/k/l 調整視窗大小
vim.keymap.set("n", "<leader>H", "<cmd>vertical resize -2<CR>", { silent = true, desc = "Shrink Width" })
vim.keymap.set("n", "<leader>L", "<cmd>vertical resize +2<CR>", { silent = true, desc = "Enlarge Width" })
vim.keymap.set("n", "<leader>K", "<cmd>resize -2<CR>", { silent = true, desc = "Shrink Height" })
vim.keymap.set("n", "<leader>J", "<cmd>resize +2<CR>", { silent = true, desc = "Enlarge Height" })

-- use Ctrl-hjkl to switch between windows (注意：會被 nvim-tmux-navigator 覆蓋)
vim.api.nvim_set_keymap("n", "<C-h>", "<C-w>h", { noremap = true, silent = true, desc = "Switch to Left Window" })
vim.api.nvim_set_keymap("n", "<C-j>", "<C-w>j", { noremap = true, silent = true, desc = "Switch to Down Window" })
vim.api.nvim_set_keymap("n", "<C-k>", "<C-w>k", { noremap = true, silent = true, desc = "Switch to Up Window" })
vim.api.nvim_set_keymap("n", "<C-l>", "<C-w>l", { noremap = true, silent = true, desc = "Switch to Right Window" })

-- next window
vim.api.nvim_set_keymap("n", "<C-n>", "<C-w>w", { noremap = true, silent = true, desc = "Next Window" })
-- previous window
vim.api.nvim_set_keymap("n", "<C-p>", "<C-w>p", { noremap = true, silent = true, desc = "Previous Window" })

-- Split window
vim.api.nvim_set_keymap("n", "<leader>v", ":vsplit<CR>", { noremap = true, silent = true, desc = "Vertical Split" })
vim.api.nvim_set_keymap("n", "<leader>s", ":split<CR>", { noremap = true, silent = true, desc = "Horizontal Split" })

-- ==========================================================================
-- 程式碼行與區塊移動 (Alt + jk)
-- ==========================================================================

-- normal
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { noremap = true, silent = true, desc = "Move Line Down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { noremap = true, silent = true, desc = "Move Line Up" })

-- insert
vim.keymap.set("i", "<A-j>", "<Esc>:m .+1<CR>==gi", { noremap = true, silent = true, desc = "Move Line Down (Insert)" })
vim.keymap.set("i", "<A-k>", "<Esc>:m .-2<CR>==gi", { noremap = true, silent = true, desc = "Move Line Up (Insert)" })

-- visual with multiple lines selected, move the block up and down
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true, desc = "Move Block Down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true, desc = "Move Block Up" })

-- ==========================================================================
-- 外部工具整合 (Tmux, Oil, File Tree, Git, Buffer)
-- ==========================================================================

-- nvim-tmux-navigator (會覆蓋 <C-h/j/k/l> 的視窗切換)
vim.api.nvim_set_keymap(
	"n",
	"<C-h>",
	"<cmd>TmuxNavigateLeft<CR>",
	{ noremap = true, silent = true, desc = "Tmux/Nvim Left" }
)
vim.api.nvim_set_keymap(
	"n",
	"<C-j>",
	"<cmd>TmuxNavigateDown<CR>",
	{ noremap = true, silent = true, desc = "Tmux/Nvim Down" }
)
vim.api.nvim_set_keymap(
	"n",
	"<C-k>",
	"<cmd>TmuxNavigateUp<CR>",
	{ noremap = true, silent = true, desc = "Tmux/Nvim Up" }
)
vim.api.nvim_set_keymap(
	"n",
	"<C-l>",
	"<cmd>TmuxNavigateRight<CR>",
	{ noremap = true, silent = true, desc = "Tmux/Nvim Right" }
)

-- Pressing <Esc> in Normal mode will clear the highlight
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { noremap = true, silent = true, desc = "Clear Search Highlight" })

-- Buffer
vim.keymap.set("n", "<leader>bd", ":bd<CR>", { desc = "Delete Buffer" })

-- File Manager
-- vim.api.nvim_set_keymap("n", "<leader>e", ":Ex<CR>", { noremap = true, silent = true, desc = "Toggle Netrw" })
-- Nvim tree
vim.api.nvim_set_keymap(
	"n",
	"<leader>e",
	":NvimTreeToggle<CR>",
	{ noremap = true, silent = true, desc = "Toggle NvimTree" }
)

-- Oil.nvim
-- open parent directory in new floating window
vim.keymap.set(
	"n",
	"<space>E",
	require("oil").toggle_float,
	{ noremap = true, silent = true, desc = "Toggle Oil Floating Window" }
)

-- Undotree
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { noremap = true, silent = true, desc = "Toggle Undotree" })

-- ==========================================================================
-- Telescope
-- ==========================================================================
-- vim.api.nvim_set_keymap(
-- 	"n",
-- 	"<leader>ff",
-- 	"<cmd>lua require'telescope.builtin'.find_files()<cr>",
-- 	{ noremap = true, silent = true, desc = "Find Files" }
-- )
-- vim.api.nvim_set_keymap(
-- 	"n",
-- 	"<leader>pf",
-- 	"<cmd>lua require'telescope.builtin'.buffers({ show_all_buffers = true })<cr>",
-- 	{ noremap = true, silent = true, desc = "Search Buffers (All)" }
-- )
-- vim.api.nvim_set_keymap(
-- 	"n",
-- 	"<leader>pg",
-- 	":Telescope git_status<CR>",
-- 	{ noremap = true, silent = true, desc = "Git Status" }
-- )
-- vim.api.nvim_set_keymap(
-- 	"n",
-- 	"<leader>ff",
-- 	":Telescope git_bcommits<CR>",
-- 	{ noremap = true, silent = true, desc = "Git Buffer Commits" }
-- )
vim.api.nvim_set_keymap(
	"n",
	"<leader>td",
	":TodoTelescope<cr>",
	{ noremap = true, silent = true, desc = "Todo Search" }
)
-- vim.api.nvim_set_keymap(
-- 	"n",
-- 	"<leader>ps",
-- 	":Telescope live_grep<CR>",
-- 	{ noremap = true, silent = true, desc = "Live Grep (Text Search)" }
-- )
-- vim.keymap.set("n", "<leader>cs", ":Telescope lsp_document_symbols<CR>", { desc = "LSP Symbols" })
-- vim.api.nvim_set_keymap(
-- 	"n",
-- 	"<leader>fh",
-- 	":Telescope help_tags<CR>",
-- 	{ noremap = true, silent = true, desc = "Search Help" }
-- )
-- vim.api.nvim_set_keymap(
-- 	"n",
-- 	"<leader>fm",
-- 	":Telescope man_pages<CR>",
-- 	{ noremap = true, silent = true, desc = "Search Man Pages" }
-- )

-- ==========================================================================
-- Git 操作 (Neogit, Gitsigns, Diffview)
-- ==========================================================================

-- Neogit
vim.api.nvim_set_keymap(
	"n",
	"<leader>gg",
	":Neogit kind=tab<CR>",
	{ noremap = true, silent = true, desc = "Neogit Status Tab" }
)

-- Gitsigns
vim.api.nvim_set_keymap(
	"n",
	"<leader>hh",
	":Gitsigns preview_hunk<CR>",
	{ noremap = true, silent = true, desc = "Preview Hunk" }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>hs",
	":Gitsigns stage_hunk<CR>",
	{ noremap = true, silent = true, desc = "Stage Hunk" }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>hu",
	":Gitsigns undo_stage_hunk<CR>",
	{ noremap = true, silent = true, desc = "Undo Stage Hunk" }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>hr",
	":Gitsigns reset_hunk<CR>",
	{ noremap = true, silent = true, desc = "Reset Hunk" }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>hR",
	":Gitsigns reset_buffer<CR>",
	{ noremap = true, silent = true, desc = "Reset Buffer" }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>hd",
	":vertical Gitsigns diffthis<CR>",
	{ noremap = true, silent = true, desc = "Vertical Diff Hunk" }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>hD",
	":Gitsigns diffthis<CR>",
	{ noremap = true, silent = true, desc = "Diff Hunk" }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>hb",
	":Gitsigns blame<CR>",
	{ noremap = true, silent = true, desc = "Toggle Blame" }
)

-- DiffView
-- 確保 Diffview 模組已載入
local diffview = require("diffview.lib")

local function diffview_toggle()
	-- 檢查 diffview.lib.views 表格是否為空。
	if next(diffview.views) then
		vim.cmd("DiffviewClose")
	else
		vim.cmd("DiffviewOpen")
	end
end
vim.keymap.set("n", "<leader>dv", diffview_toggle, { noremap = true, silent = true, desc = "Toggle Diffview" })

-- ==========================================================================
-- Quickfix, Harpoon, LSP, DAP
-- ==========================================================================

-- Quickfix List
vim.keymap.set("n", "[q", ":cprev<CR>", { noremap = true, silent = true, desc = "Previous Quickfix Item" })
vim.keymap.set("n", "]q", ":cnext<CR>", { noremap = true, silent = true, desc = "Next Quickfix Item" })
-- Quicker
vim.keymap.set("n", "<leader>l", function()
	require("quicker").toggle()
end, {
	desc = "Toggle quickfix",
})

-- vim.keymap.set("n", "<leader>ll", function()
-- 	require("quicker").toggle({ loclist = true })
-- end, {
-- 	desc = "Toggle loclist",
-- })

-- lsp restart
vim.keymap.set("n", "<leader>R", function()
	-- 取得當前 buffer 附加的所有 LSP 客戶端
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if #clients == 0 then
		-- vim.notify("No LSP clients attached to this buffer", "warn", { title = "LSP" })
		vim.notify("No LSP clients attached. Reloading buffer...", "warn", { title = "LSP" })
		vim.cmd("edit!")
		return
	end

	-- 停止當前 buffer 的 LSP
	for _, client in ipairs(clients) do
		vim.lsp.stop_client(client.id)
	end

	vim.diagnostic.reset()

	-- 稍微延遲後重新載入檔案以重新附加 LSP
	vim.defer_fn(function()
		vim.cmd("edit!")
		vim.notify("LSP restarted for current buffer", "info", { title = "LSP" })
	end, 50)
end, { noremap = true, silent = true, desc = "Restart LSP for current buffer" })

-- DAP
vim.keymap.set("n", "<leader>du", function()
	require("dapui").toggle()
end, { noremap = true, silent = true, desc = "Toggle DAP UI" })

vim.keymap.set(
	"n",
	"<leader>db",
	":DapToggleBreakpoint<CR>",
	{ noremap = true, silent = true, desc = "Set DAP breakpoint" }
)

vim.keymap.set("n", "<leader>dc", ":DapContinue<CR>", { noremap = true, silent = true, desc = "DAP Continue" })

vim.keymap.set({ "n", "v" }, "<leader>dw", function()
	require("dapui").eval(nil, { enter = true })
end, { noremap = true, silent = true, desc = "Add word under cursor to Watches" })

vim.keymap.set({ "n", "v" }, "Q", function()
	require("dapui").eval()
end, {
	noremap = true,
	silent = true,
	desc = "Hover/eval a single value",
})

-- Harpoon
local harpoon = require("harpoon")
vim.keymap.set("n", "<leader>a", function()
	harpoon:list():add()
end, { noremap = true, silent = true, desc = "Harpoon: Add File" })

vim.keymap.set("n", "<leader>fj", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end, { noremap = true, silent = true, desc = "Harpoon: Quick Menu" })

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<A-h>", function()
	harpoon:list():prev()
end, { noremap = true, silent = true, desc = "Harpoon: Previous File" })

vim.keymap.set("n", "<A-l>", function()
	harpoon:list():next()
end, { noremap = true, silent = true, desc = "Harpoon: Next File" })

-- ==========================================================================
-- Go testing (已備份註解)
-- ==========================================================================

-- vim.keymap.set("n", "<leader>tt", function()
-- 	if vim.bo.filetype == "go" then
-- 		vim.cmd("GoTestFile")
-- 		vim.notify("Running GoTestFile", "info", {
-- 			title = "Golang",
-- 		})
-- 	else
-- 		vim.notify("This filetype not supported for test file", "error", {
-- 			title = "Golang",
-- 		})
-- 	end
-- end, { noremap = true, silent = true, desc = "Go: Test File" })
--
-- vim.keymap.set("n", "<leader>tc", function()
-- 	if vim.bo.filetype == "go" then
-- 		vim.cmd("GoTestFunc")
-- 		vim.notify("Running GoTestFunc", "info", {
-- 			title = "Golang",
-- 		})
-- 	else
-- 		vim.notify("This filetype not supported for test function", "error", {
-- 			title = "Golang",
-- 		})
-- 	end
-- end, { noremap = true, silent = true, desc = "Go: Test Function" })
--
-- vim.keymap.set("n", "<leader>tp", function()
-- 	if vim.bo.filetype == "go" then
-- 		vim.cmd("GoTestPkg")
-- 		vim.notify("Running GoTestPkg", "info", {
-- 			title = "Golang",
-- 		})
-- 	else
-- 		vim.notify("This filetype not supported for test pkg", "error", {
-- 			title = "Golang",
-- 		})
-- 	end
-- end, { noremap = true, silent = true, desc = "Go: Test Package" })
--
-- vim.keymap.set("n", "<leader>ta", function()
-- 	if vim.bo.filetype == "go" then
-- 		vim.cmd("GoTestSum")
-- 		vim.notify("Running GoTestSum", "info", {
-- 			title = "Golang",
-- 		})
-- 	else
-- 		vim.notify("This filetype not supported for test sum", "error", {
-- 			title = "Golang",
-- 		})
-- 	end
-- end, { noremap = true, silent = true, desc = "Go: Test Summary" })
