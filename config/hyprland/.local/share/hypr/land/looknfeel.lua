---------------------
---- Look & Feel ----
---------------------

-- ==========================================
-- 顏色風格選單
-- ==========================================

-- [Original] 北歐青 (Nordic Aqua) - 沉穩、專業
-- local activeBorderColor = { colors = { "0x33ccffee", "0x00ff99ee" }, angle = 45 }
-- local inactiveBorderColor = "0x595959aa"

-- [Cyberpunk] 霓虹粉藍 (Vaporwave) - 高對比
-- local activeBorderColor = { colors = { "0xff00ffee", "0x00ffffee" }, angle = 45 }
-- local inactiveBorderColor = "0x444444aa"

-- [Lava] 地獄烈焰 (Magma) - 侵略性
-- local activeBorderColor = { colors = { "0xff4500ee", "0x800080ee" }, angle = 45 }
-- local inactiveBorderColor = "0x333333aa"

-- [Electric] 電子脈衝 (Pulse) - 極致亮眼
-- local activeBorderColor = { colors = { "0xffff00ee", "0x8a2be2ee" }, angle = 45 }
-- local inactiveBorderColor = "0x2a2a2aaa"

-- [Forest] 深邃翡翠 (Emerald) - 高雅護眼
-- local activeBorderColor = { colors = { "0x00ff9f99", "0x006633ee" }, angle = 45 }
-- local inactiveBorderColor = "0x202020aa"

-- [NeonGreen] 極致亮綠
-- local activeBorderColor = { colors = { "rgba(39ff14ee)", "rgba(008f11ee)" }, angle = 45 }
-- local inactiveBorderColor = "rgba(404040aa)" -- 故意設得深一點，讓活躍的更跳出來

-- [SkyBlue] 天空藍
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
		auto_group = true,
		groupbar = {
			enabled = true,
			height = 20,
			font_size = 12,
			font_family = "comic code",
			render_titles = true,
			col = {
				active = "0xff39ff14",
				inactive = "0xff204020",
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
