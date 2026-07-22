return {
	{
		"vimwiki/vimwiki",
		init = function()
			vim.g.vimwiki_list = {
				{
					path = "~/Documents/vimwiki/",
					syntax = "markdown",
					ext = "md",
				},
			}
		end,
		config = function()
			vim.api.nvim_create_autocmd({ "FileType" }, {
				pattern = { "vimwiki", "markdown" },
				callback = function()
					vim.keymap.set("n", "<C-Space>", function()
						local line = vim.api.nvim_get_current_line()

						-- check if the line is a list item
						if line:match("%[[ %.oOX]%]") then
							local new_line

							-- a loop of [ ] -> [.] -> [o] -> [O] -> [X]
							-- on <C-Space> shortcut

							if line:match("%[ %]") then
								new_line = line:gsub("%[ %]", "[.]", 1)
							elseif line:match("%[%.%]") then
								new_line = line:gsub("%[%.%]", "[o]", 1)
							elseif line:match("%[o%]") then
								new_line = line:gsub("%[o%]", "[O]", 1)
							elseif line:match("%[O%]") then
								new_line = line:gsub("%[O%]", "[X]", 1)
							elseif line:match("%[X%]") then
								new_line = line:gsub("%[X%]", "[ ]", 1)
							else
								return
							end

							--  set it
							vim.api.nvim_set_current_line(new_line)
						end
					end, { buffer = true, silent = true })
				end,
			})
		end,
	},
}
