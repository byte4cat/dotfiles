---@diagnostic disable: undefined-global
------------------------
----- TRANSPARENT ------
------------------------

-- 全局基礎透明度
hl.window_rule({
	name = "global-transparent",
	match = { class = ".*" },
	opacity = "0.96 override 0.96 override 0.96 override",
})

-- 瀏覽器 強制完全不透明
hl.window_rule({
	name = "browser-transparent",
	match = { class = "^(firefox|brave-browser|google-chrome|chromium|zen|librewolf)$" },
	opacity = "1.0 override 1.0 override 1.0 override",
})

-- 通訊軟體 強制完全不透明
hl.window_rule({
	name = "msg-transparent",
	match = { class = "^(vesktop|Signal)$" },
	opacity = "1.0 override 1.0 override 1.0 override",
})

-- 媒體播放器 強制完全不透明
hl.window_rule({
	name = "media-transparent",
	match = { class = "^(mpv|vlc|ffplay)$" },
	opacity = "1.0 override 1.0 override 1.0 override",
})

-- 終端機 獨立高透明度
hl.window_rule({
	name = "terminal-transparent",
	match = { class = "^(com\\.mitchellh\\.ghostty|Alacritty|kitty|foot)$" },
	opacity = "0.90 override 0.90 override 0.90 override",
	no_blur = true,
})

-- hl.window_rule({
-- 	name = "terminal-alacritty-transparent",
-- 	match = { class = "^(Alacritty)$" },
-- 	opacity = "0.80 override 0.80 override 0.80 override",
-- 	no_blur = false,
-- })

-- 終端機全螢幕時：稍微調低透明度以專注 (0.90)
hl.window_rule({
	name = "terminal-fullscreen-opacity",
	match = {
		class = "^(com\\.mitchellh\\.ghostty|Alacritty|kitty|foot)$",
		fullscreen = "1",
	},
	opacity = "0.95 override 0.95 override 0.95 override",
	no_blur = false,
})
