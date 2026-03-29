return {
	{ "nvim-lua/plenary.nvim" },

	{
		"David-Kunz/gen.nvim",
		opts = {
			model = "qwen2.5-coder:7b",
			display_mode = "float",
			show_model = true,
			init = function() end,
		},
		keys = {
			{ "<leader>aa", ":Gen<CR>", mode = { "n", "v" }, desc = "Ollama Menu" },
			{ "<leader>ae", ":Gen Enhance_Code<CR>", mode = { "v" }, desc = "AI 優化選中代碼" },
			{ "<leader>ad", ":Gen Chat<CR>", mode = { "n", "v" }, desc = "與 AI 對談" },
		},
	},
}
