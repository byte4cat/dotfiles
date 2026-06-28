return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	config = function()
		require("copilot").setup({
			panel = { enabled = false },
			suggestion = {
				enabled = true,
				auto_trigger = true, -- 💡 打字時自動顯示建議
				debounce = 250,
				keymap = {
					accept = "<M-l>",
					accept_word = false,
					accept_line = false,
					next = "<M-]>",
					prev = "<M-[>",
					dismiss = "<C-e>",
				},
			},
			filetypes = {
				rust = true,
				go = true,
				lua = true,
				python = true,
				c = true,
				markdown = true,
				help = false,
				gitcommit = false,
				gitrebase = false,
				["."] = false,
			},
		})
	end,
}
