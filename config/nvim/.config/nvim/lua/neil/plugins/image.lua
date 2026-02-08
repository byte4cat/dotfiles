return {
	"3rd/image.nvim",
	build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
	opts = {
		processor = "magick_cli",
	},
	ft = { "markdown" },
	-- copy from default settings
	config = function()
		require("image").setup({
			backend = "kitty",
			kitty_method = "normal",
			processor = "magick_cli",
			max_width = 60, -- 寬度限制在 100 格字元內
			max_height = 12, -- 高度限制在 12 行內
			max_height_window_percentage = 50,
			max_width_window_percentage = nil, -- 關閉寬度百分比限制，改用固定數值
			integrations = {
				markdown = {
					enabled = true,
					download_remote_images = true,
					only_render_image_at_cursor = true,
					clear_in_insert_mode = true,
					filetypes = { "markdown", "vimwiki" },
					with_virtual_padding = true,
				},
			},
			window_overlap_clear_enabled = true,
		})
	end,
}
