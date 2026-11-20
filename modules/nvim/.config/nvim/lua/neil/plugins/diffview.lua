return {
	"sindrets/diffview.nvim",
	config = function()
		local actions = require("diffview.actions")
		local DiffView = require("diffview.scene.views.diff.diff_view").DiffView
		local Diff1 = require("diffview.scene.layouts.diff_1").Diff1

		-- Whole-file backgrounds for added (green) and deleted (red) files, taken from the
		-- colorscheme's DiffAdd / DiffDelete so they follow theme changes.
		local function set_whole_file_hl()
			local function bg_of(name, fallback)
				local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
				return hl.bg or fallback
			end
			vim.api.nvim_set_hl(0, "DiffviewWholeFileAdded", { bg = bg_of("DiffAdd", "#1f3a26") })
			vim.api.nvim_set_hl(0, "DiffviewWholeFileDeleted", { bg = bg_of("DiffDelete", "#3f1f22") })
		end
		set_whole_file_hl()
		vim.api.nvim_create_autocmd("ColorScheme", { callback = set_whole_file_hl })

		-- Diffview applies a file's winopts when it opens it and restores them when it leaves.
		local function tint(file, group)
			file.winopts = vim.tbl_extend("force", file.winopts or {}, {
				winhl = { "Normal:" .. group, "NormalNC:" .. group, "EndOfBuffer:" .. group },
			})
		end

		-- <leader>e toggles the file panel inside diffview (like NvimTreeToggle elsewhere)
		local toggle_files = { "n", "<leader>e", actions.toggle_files, { desc = "Toggle the file panel" } }

		require("diffview").setup({
			view = {
				-- Stack old/new top and bottom so each side gets the full width.
				-- Press g<C-x> to cycle back to side by side when needed.
				default = { layout = "diff2_vertical" },
				file_history = { layout = "diff2_vertical" },
			},
			file_panel = {
				win_config = { position = "right", width = 35 },
			},
			file_history_panel = {
				win_config = { position = "right", width = 35 },
			},
			hooks = {
				-- Start DiffviewOpen with the file panel hidden; <Tab>/<S-Tab> still move between files.
				-- File history keeps its panel, since it is the list of commits.
				view_opened = function(view)
					-- Added, untracked and deleted files have one empty side: show only the side with content.
					view.emitter:on("file_open_pre", function(_, entry)
						if not entry or entry.layout:instanceof(Diff1) then
							return
						end
						if entry.status == "A" or entry.status == "?" then
							entry:convert_layout(Diff1)
							tint(entry.layout.b.file, "DiffviewWholeFileAdded")
						elseif entry.status == "D" and entry.layout.a then
							-- Diff1 shows its "b" window, so put the old (deleted) file there.
							entry.layout = Diff1({ b = entry.layout.a.file })
							tint(entry.layout.b.file, "DiffviewWholeFileDeleted")
						end
					end)

					if view:instanceof(DiffView) then
						vim.schedule(function()
							view.panel:close()
						end)
					end
				end,
			},
			keymaps = {
				view = { toggle_files },
				file_panel = { toggle_files },
				file_history_panel = { toggle_files },
			},
		})
	end,
}
