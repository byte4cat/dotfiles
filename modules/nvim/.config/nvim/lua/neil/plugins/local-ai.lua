return {
	"milanglacier/minuet-ai.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		require("minuet").setup({
			debounce = 600,
			throttle = 1500,
			provider = "openai_fim_compatible",
			n_completions = 1,
			context_window = 512,
			provider_options = {
				openai_fim_compatible = {
					api_key = "TERM",
					name = "Ollama",
					end_point = "http://localhost:11434/v1/completions",
					model = "qwen2.5-coder:3b", -- 預設啟動的模型
					optional = {
						max_tokens = 256,
						top_p = 0.9,
					},
				},
			},
			virtualtext = {
				auto_trigger_ft = { "*" },
				keymap = {
					accept = "<A-a>",
					dismiss = "<A-d>",
				},
			},
			presets = {
				normal = {
					provider = "openai_fim_compatible",
					context_window = 512,
					provider_options = {
						openai_fim_compatible = {
							model = "qwen2.5-coder:7b",
							api_key = "TERM",
							name = "Ollama",
							end_point = "http://localhost:11434/v1/completions",
						},
					},
				},

				fast = {
					provider = "openai_fim_compatible",
					context_window = 512,
					provider_options = {
						openai_fim_compatible = {
							model = "qwen2.5-coder:3b",
							api_key = "TERM",
							name = "Ollama",
							end_point = "http://localhost:11434/v1/completions",
						},
					},
				},

				fast = {
					provider = "openai_fim_compatible",
					context_window = 512,
					provider_options = {
						openai_fim_compatible = {
							model = "qwen2.5-coder:3b",
							api_key = "TERM",
							name = "Ollama",
							end_point = "http://localhost:11434/v1/completions",
						},
					},
				},

				heavy = {
					provider = "openai_fim_compatible",
					context_window = 2048,
					provider_options = {
						openai_fim_compatible = {
							model = "qwen2.5-coder:14b",
							api_key = "TERM",
							name = "Ollama",
							end_point = "http://localhost:11434/v1/completions",
						},
					},
				},
			},
		})
	end,
}
