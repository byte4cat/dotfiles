-- show prev view
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { noremap = true, silent = true, desc = "Show previous view (Ex)" })

vim.api.nvim_set_keymap("i", "jk", "<Esc>", { noremap = true, silent = true, desc = "Exit Insert Mode" })

-- 使用 <F1> 切換到下一個文檔 (注意：這會覆蓋下一行的 <F1> 設置)
vim.api.nvim_set_keymap("n", "<F1>", ":bnext<CR>", { noremap = true, silent = true, desc = "Next Buffer" })
-- 使用 <F1> 切換到前一個文檔 (此行會覆蓋上一行的 <F1> 設置，但 desc 不會顯示)
vim.api.nvim_set_keymap("n", "<F1>", ":bprev<CR>", { noremap = true, silent = true, desc = "Previous Buffer" })
-- 建議將其中一個改成 <F2>
vim.api.nvim_set_keymap("n", "<F2>", ":bprev<CR>", { noremap = true, silent = true, desc = "Previous Buffer" })

-- 使用 <F3> 交換當前視窗和下一個視窗的位置
vim.api.nvim_set_keymap("n", "<F3>", "<C-w>x", { noremap = true, silent = true, desc = "Swap Window Position" })

-- 使用 Ctrl+Shift--hjkl 來調整視窗大小
vim.api.nvim_set_keymap("n", "<leader>H", "<C-w><", { noremap = true, silent = true, desc = "Shrink Window Width" })
vim.api.nvim_set_keymap("n", "<leader>J", "<C-w>+", { noremap = true, silent = true, desc = "Enlarge Window Height" })
vim.api.nvim_set_keymap("n", "<leader>K", "<C-w>-", { noremap = true, silent = true, desc = "Shrink Window Height" })
vim.api.nvim_set_keymap("n", "<leader>L", "<C-w>>", { noremap = true, silent = true, desc = "Enlarge Window Width" })

-- use Ctrl-hjkl to switch between windows (注意：會被 nvim-tmux-navigator 覆蓋)
vim.api.nvim_set_keymap("n", "<C-h>", "<C-w>h", { noremap = true, silent = true, desc = "Switch to Left Window" })
vim.api.nvim_set_keymap("n", "<C-j>", "<C-w>j", { noremap = true, silent = true, desc = "Switch to Down Window" })
vim.api.nvim_set_keymap("n", "<C-k>", "<C-w>k", { noremap = true, silent = true, desc = "Switch to Up Window" })
vim.api.nvim_set_keymap("n", "<C-l>", "<C-w>l", { noremap = true, silent = true, desc = "Switch to Right Window" })

-- next window
vim.api.nvim_set_keymap("n", "<C-n>", "<C-w>w", { noremap = true, silent = true, desc = "Next Window" })
-- previous window
vim.api.nvim_set_keymap("n", "<C-p>", "<C-w>p", { noremap = true, silent = true, desc = "Previous Window" })

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

-- Split window
vim.api.nvim_set_keymap("n", "<leader>v", ":vsplit<CR>", { noremap = true, silent = true, desc = "Vertical Split" })
vim.api.nvim_set_keymap("n", "<leader>s", ":split<CR>", { noremap = true, silent = true, desc = "Horizontal Split" })

-- Pressing <Esc> in Normal mode will clear the highlight
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { noremap = true, silent = true, desc = "Clear Search Highlight" })

-- lsp restart
vim.keymap.set("n", "<leader>R", function()
	vim.cmd("LspRestart")
	vim.notify("Language server restarted", "info", {
		title = "LSP",
	})
end, { noremap = true, silent = true, desc = "LSP Restart" })

-- Nvim tree
vim.api.nvim_set_keymap(
	"n",
	"<leader>e",
	":NvimTreeToggle<CR>",
	{ noremap = true, silent = true, desc = "Toggle NvimTree" }
)

-- Fold
-- Key mappings for folding and unfolding
vim.api.nvim_set_keymap("n", "zj", ":foldopen!<CR>", { noremap = true, silent = true, desc = "Fold Open Cursor" })
vim.api.nvim_set_keymap("n", "zk", ":foldclose!<CR>", { noremap = true, silent = true, desc = "Fold Close Cursor" })

-- enable or disable fold
vim.keymap.set("n", "<leader>zm", function()
	if vim.wo.foldenable then
		vim.opt.foldenable = false
		vim.opt.foldlevel = 99
		vim.notify("Fold disable", "info", {
			title = "Editor",
		})
	else
		vim.opt.foldenable = true
		vim.opt.foldlevel = 0
		vim.notify("Fold enable", "info", {
			title = "Editor",
		})
	end
end, { noremap = true, silent = true, desc = "Toggle Folding" })

-- Telescope
-- vim.api.nvim_set_keymap(
-- 	"n",
-- 	"<leader>ff",
-- 	"<cmd>lua require'telescope.builtin'.find_files()<cr>",
-- 	{ noremap = true, silent = true, desc = "Find Files" }
-- )
-- vim.api.nvim_set_keymap(
-- 	"n",
-- 	"<leader>fd",
-- 	"<cmd>lua require'telescope.builtin'.buffers({ show_all_buffers = true })<cr>",
-- 	{ noremap = true, silent = true, desc = "Search Buffers (All)" }
-- )
-- vim.api.nvim_set_keymap(
-- 	"n",
-- 	"<leader>fg",
-- 	":Telescope git_status<CR>",
-- 	{ noremap = true, silent = true, desc = "Git Status" }
-- )
-- vim.api.nvim_set_keymap(
-- 	"n",
-- 	"<leader>fb",
-- 	":Telescope git_bcommits<CR>",
-- 	{ noremap = true, silent = true, desc = "Git Buffer Commits" }
-- )
vim.api.nvim_set_keymap(
	"n",
	"<leader>pd",
	":TodoTelescope<cr>",
	{ noremap = true, silent = true, desc = "Todo Search" }
)
-- vim.api.nvim_set_keymap(
-- 	"n",
-- 	"<leader>ft",
-- 	":Telescope live_grep<CR>",
-- 	{ noremap = true, silent = true, desc = "Live Grep (Text Search)" }
-- )
-- vim.api.nvim_set_keymap(
-- 	"n",
-- 	"<leader>fh",
-- 	":Telescope help_tags<CR>",
-- 	{ noremap = true, silent = true, desc = "Search Help" }
-- )
vim.api.nvim_set_keymap(
	"n",
	"<leader>fm",
	":Telescope man_pages<CR>",
	{ noremap = true, silent = true, desc = "Search Man Pages" }
)

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

-- Quickfix List
vim.keymap.set("n", "[c", ":cnext<CR>", { noremap = true, silent = true, desc = "Next Quickfix Item" })
vim.keymap.set("n", "]c", ":cprev<CR>", { noremap = true, silent = true, desc = "Previous Quickfix Item" })

-- Oil.nvim
-- open parent directory in new floating window
vim.keymap.set(
	"n",
	"<space>-",
	require("oil").toggle_float,
	{ noremap = true, silent = true, desc = "Toggle Oil Floating Window" }
)

-- Undotree
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { noremap = true, silent = true, desc = "Toggle Undotree" })

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

-- Toggle previous & next juffers stored within Harpoon list
vim.keymap.set("n", "<leader>k", function()
	harpoon:list():prev()
end, { noremap = true, silent = true, desc = "Harpoon: Previous File" })

vim.keymap.set("n", "<leader>j", function()
	harpoon:list():next()
end, { noremap = true, silent = true, desc = "Harpoon: Next File" })

-- Go testing
vim.keymap.set("n", "<leader>tt", function()
	if vim.bo.filetype == "go" then
		vim.cmd("GoTestFile")
		vim.notify("Running GoTestFile", "info", {
			title = "Golang",
		})
	else
		vim.notify("This filetype not supported for test file", "error", {
			title = "Golang",
		})
	end
end, { noremap = true, silent = true, desc = "Go: Test File" })

vim.keymap.set("n", "<leader>tc", function()
	if vim.bo.filetype == "go" then
		vim.cmd("GoTestFunc")
		vim.notify("Running GoTestFunc", "info", {
			title = "Golang",
		})
	else
		vim.notify("This filetype not supported for test function", "error", {
			title = "Golang",
		})
	end
end, { noremap = true, silent = true, desc = "Go: Test Function" })

vim.keymap.set("n", "<leader>tp", function()
	if vim.bo.filetype == "go" then
		vim.cmd("GoTestPkg")
		vim.notify("Running GoTestPkg", "info", {
			title = "Golang",
		})
	else
		vim.notify("This filetype not supported for test pkg", "error", {
			title = "Golang",
		})
	end
end, { noremap = true, silent = true, desc = "Go: Test Package" })

vim.keymap.set("n", "<leader>ta", function()
	if vim.bo.filetype == "go" then
		vim.cmd("GoTestSum")
		vim.notify("Running GoTestSum", "info", {
			title = "Golang",
		})
	else
		vim.notify("This filetype not supported for test sum", "error", {
			title = "Golang",
		})
	end
end, { noremap = true, silent = true, desc = "Go: Test Summary" })
