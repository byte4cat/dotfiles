---------------------
---- Look & Feel ----
---------------------

-- 顏色變數
local activeBorderColor = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 }
local inactiveBorderColor = "rgba(595959aa)"
local shadowColor = "rgba(1a1a1aee)"

hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 5,
		border_size = 2,
		col = {
			active_border = activeBorderColor,
			inactive_border = inactiveBorderColor,
		},
		resize_on_border = false,
		allow_tearing = false,
		layout = "dwindle",
	},

	decoration = {
		rounding = 5,
		shadow = {
			enabled = true,
			range = 2,
			render_power = 3,
			color = shadowColor,
		},
		blur = {
			enabled = false,
			size = 3,
			passes = 1,
		},
	},

	group = {
		["col.border_active"] = activeBorderColor,
		["col.border_inactive"] = inactiveBorderColor,
		groupbar = {
			enabled = false,
			font_size = 12,
			font_family = "comic code",
			height = 22,
			col = {
				active = "rgba(00000040)",
				inactive = "rgba(00000020)",
			},
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

hl.layer_rule({ name = "blur", match = "namespace:lockscreen" })
hl.layer_rule({ name = "ignorealpha 0.7", match = "namespace:lockscreen" })

-- 動態自定義貝茲曲線與動畫
hl.curve("myBezier", { type = "bezier", points = { { 0.10, 0.9 }, { 0.1, 1.05 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "myBezier", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "myBezier", style = "slide" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default" })
