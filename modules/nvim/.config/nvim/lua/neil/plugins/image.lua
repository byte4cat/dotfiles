return {
	"3rd/image.nvim",
	build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
	event = "VeryLazy",
	opts = {
		processor = "magick_cli",
	},
	config = function()
		local image = require("image")
		image.setup({
			backend = "kitty",
			kitty_method = "normal",
			processor = "magick_cli",
			max_width = 80,
			max_height = 16,
			max_height_window_percentage = 50,
			max_width_window_percentage = 20,
			integrations = {
				markdown = {
					enabled = true,
					download_remote_images = true,
					only_render_image_at_cursor = true,
					clear_in_insert_mode = true,
					filetypes = { "markdown", "vimwiki" },
					with_virtual_padding = true,
				},
				typst = {
					enabled = true,
					download_remote_images = true,
					only_render_image_at_cursor = true,
					clear_in_insert_mode = true,
					filetypes = { "typst" },
					with_virtual_padding = true,
				},
			},
			window_overlap_clear_enabled = true,
		})
	end,
}
