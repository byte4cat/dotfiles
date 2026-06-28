---------------------
---- Look & Feel ----
---------------------

-- 載入 Matugen 生成的 Lua 色彩模組
-- 確保路徑在 package.path 中，或者直接使用絕對路徑載入
package.path = package.path .. ";" .. os.getenv("HOME") .. "/.local/share/hypr/land/colors.lua"
local c = require("colors")

hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 5,
		border_size = 2,

		-- 直接讀取 Lua 表格中的色彩
		col = {
			active_border = c.primary,
			inactive_border = c.outline_variant,
		},
		resize_on_border = false,
		allow_tearing = false,
		layout = "dwindle",
	},

	decoration = {
		rounding = 5,
		rounding_power = 2,
		shadow = {
			enabled = false,
			range = 2,
			render_power = 3,
			color = c.shadow,
		},
		blur = {
			enabled = true,
			size = 15,
			passes = 3,
			ignore_opacity = true,
			noise = 0.08,
			contrast = 1.5,
			xray = true,
			new_optimizations = true,
		},
	},

	group = {
		col = {
			border_active = c.primary,
			border_inactive = c.outline_variant,
		},
		auto_group = true,

		groupbar = {
			enabled = true,
			font_size = 12,
			font_family = "comic code",
			font_weight_active = "ultraheavy",
			font_weight_inactive = "normal",
			indicator_height = 0,
			indicator_gap = 5,
			height = 20,
			gaps_in = 5,
			gaps_out = 5,

			text_color = c.on_surface,
			text_color_inactive = c.on_surface_variant,
			col = {
				active = c.primary_container,
				inactive = c.surface_variant,
			},
			gradients = true,
			gradient_rounding = 0,
			gradient_round_only_edges = false,
		},
	},

	animations = {
		enabled = false, -- no, thx :)
	},

	misc = {
		vrr = 1,
		force_default_wallpaper = -1,
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		focus_on_activate = true,
		anr_missed_pings = 3,
	},

	dwindle = {
		preserve_split = true,
	},

	master = {
		new_status = "master",
	},
})

-- Layer rules
hl.layer_rule({ name = "blur", match = "namespace:lockscreen" })
hl.layer_rule({ name = "ignorealpha 0.7", match = "namespace:lockscreen" })
