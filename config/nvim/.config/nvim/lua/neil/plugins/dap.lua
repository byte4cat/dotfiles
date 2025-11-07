return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-neotest/nvim-nio",
			"leoluz/nvim-dap-go", -- this is not required for nvim-dap
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			dap.adapters.go = {
				type = "server",
				port = "${port}",
				executable = {
					command = "dlv",
					args = { "dap", "-l", "127.0.0.1:${port}" },
					-- add this if on windows, otherwise server won't open successfully
					-- detached = false
				},
			}

			-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
			dap.configurations.go = {
				{
					type = "go",
					name = "Debug project",
					request = "launch",
					-- program to your project main file
					program = "${workspaceFolder}/cmd/main.go",
				},
				{
					type = "go",
					name = "Debug file",
					request = "launch",
					program = "${file}",
				},
				{
					type = "go",
					name = "Debug test", -- configuration for debugging test files
					request = "launch",
					mode = "test",
					program = "${file}",
				},
				-- works with go.mod packages and sub packages
				{
					type = "go",
					name = "Debug test (go.mod)",
					request = "launch",
					mode = "test",
					program = "./${relativeFileDirname}",
				},
			}

			dapui.setup({
				expand_lines = true,
				controls = { enabled = true }, -- no extra play/step buttons
				floating = { border = "rounded" },
				-- Set dapui window
				render = {
					max_type_length = 60,
					max_value_lines = 200,
				},
				-- Only one layout: just the "scopes" (variables) list at the bottom
				layouts = {
					{
						elements = {
							{ id = "scopes", size = 1.0 }, -- 100% of this panel is scopes
						},
						size = 15, -- height in lines (adjust to taste)
						position = "bottom", -- "left", "right", "top", "bottom"
					},
				},
			})

			-- open the ui as soon as we are debugging
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end
		end,
	},
}
