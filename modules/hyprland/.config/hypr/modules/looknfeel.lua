---@diagnostic disable: undefined-global
---------------------
---- Look & Feel ----
---------------------

-- 載入 Matugen 生成的 Lua 色彩模組
hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 5,
		border_size = 2,

		-- 直接讀取 Lua 表格中的色彩
		col = {
			active_border = _G.colors.primary,
			inactive_border = _G.colors.outline_variant,
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
			color = _G.colors.shadow,
		},
		blur = {
			enabled = true,
			size = 15,
			passes = 3,
			ignore_opacity = true,
			noise = 0.08,
			contrast = 1.5,
			xray = false,
			new_optimizations = true,
		},
	},

	group = {
		col = {
			border_active = _G.colors.primary,
			border_inactive = _G.colors.outline_variant,
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

			text_color = _G.colors.on_surface,
			text_color_inactive = _G.colors.on_surface_variant,
			col = {
				active = _G.colors.primary_container,
				inactive = _G.colors.surface_variant,
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
