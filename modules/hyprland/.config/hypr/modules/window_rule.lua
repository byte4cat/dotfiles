---@diagnostic disable: undefined-global
--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- 基礎視窗規則
hl.window_rule({
	name = "suppress-maximize-events",
	match = { class = ".*" },
	suppress_event = "maximize",
})

hl.window_rule({
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})

-- 設定當工作區只有一個可見視窗或全螢幕時，gaps 歸零
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 })
-- 如果連單視窗時的邊框與圓角也想一併清除
-- hl.window_rule({ match = { float = false, workspace = "w[tv1]" }, border_size = 0 })
-- hl.window_rule({ match = { float = false, workspace = "w[tv1]" }, rounding = 0 })

-- 當視窗是show me the key 時, disable border
hl.window_rule({
	match = { class = "^(one.alynx.showmethekey)$" },
	border_size = 0,
})

-- 常用工具規則
hl.window_rule({
	name = "pavucontrol-window",
	match = { class = "^(org.pulseaudio.pavucontrol)$" },
	float = true,
	center = true,
	size = { "(monitor_w * 0.8)", "(monitor_h * 0.5)" },
})

hl.window_rule({
	name = "waypaper-window",
	match = { class = "^(waypaper)$" },
	float = true,
	center = true,
	size = { "(monitor_w * 0.6)", "(monitor_h * 0.8)" },
})

-- LINE (Wine/Bottles): 固定視窗大小。
-- LINE 自己畫邊框，被 Hyprland 拖曳縮放後內容不會重畫（外框變大、內容停在舊尺寸、
-- 其餘是黑的），所以不讓 Hyprland 調整大小。只匹配主視窗（title = LINE），
-- 邊框／陰影用的輔助視窗標題是空的，不可限制大小。
-- 注意：Hyprland 不會因為 modules/*.lua 改動而自動重載，改完要 `hyprctl reload`；
-- 規則只在視窗開啟時套用，已開著的 LINE 需關掉重開。
-- 背景與完整說明見 bin/install_line_bottles 開頭的 Notes。
hl.window_rule({
	name = "line-wine-fixed-size",
	match = { class = "^(line\\.exe)$", title = "^LINE$" },
	float = true,
	center = true,
	size = { "(monitor_w * 0.5)", "(monitor_h * 0.9)" },
	min_size = { "(monitor_w * 0.5)", "(monitor_h * 0.9)" },
	max_size = { "(monitor_w * 0.5)", "(monitor_h * 0.9)" },
})

-- Show Me The Key (展示工具)
hl.window_rule({
	name = "key-display-overlay",
	match = { class = "^(showmethekey-gtk)$" },
	float = true,
	pin = true,
	no_initial_focus = true,
	no_focus = true,
	no_shadow = true,
	move = { "(monitor_w * 0.8)", "(monitor_h * 0.8)" },
	size = { 600, 150 },
})

-- 媒體與攝像頭規則
hl.window_rule({
	name = "media-players-window",
	match = { class = "^(mpv|ffplay)$" },
	float = true,
	center = true,
	size = { 800, 450 },
})

hl.window_rule({
	name = "satty-screenshot",
	match = { class = "^(com\\.gabm\\.satty)$" },
	float = true,
	center = true,
	pin = true,
	size = { "(monitor_w * 0.5)", "(monitor_h * 0.5)" },
})

-- 2k resolution
-- hl.window_rule({
-- 	name = "babycam-window",
-- 	match = { initial_title = "BabyCam" },
-- 	monitor = myEnv.primaryMonitor,
-- 	size = { 320, 180 },
-- 	move = { "(monitor_w * 0.87)", "(monitor_h * 0.865)" },
-- 	float = true,
-- 	pin = true,
-- })

-- FHD resolution
hl.window_rule({
	name = "babycam-window",
	match = { initial_title = "BabyCam" },
	monitor = myEnv.primaryMonitor,
	size = { 320, 180 },
	move = { "(monitor_w * 0.83)", "(monitor_h * 0.83)" },
	float = true,
	pin = true,
})

-- Special Workspaces 樣式與自動分配
-- Scratchpad (Ghostty/Tmux)
hl.window_rule({
	name = "scratchpadterm-auto-style",
	match = { workspace = "special:scratchpad-term", class = "^(com.mitchellh.ghostty|Alacritty|kitty|foot)$" },
	size = { "(monitor_w * 0.7)", "(monitor_h * 0.7)" },
	float = true,
	center = true,
	opacity = "0.9 override 0.1 override 1.0 override", -- active/inactive/fullscreen 三段
})

-- Music (Spotify)
hl.window_rule({
	name = "init-music",
	match = { class = "^(Spotify)$" },
	workspace = "special:music silent",
})

-- 通訊軟體分配
hl.window_rule({
	name = "place-work-msg",
	match = { initial_class = "^(vesktop)$" },
	workspace = "special:work-msg silent",
})
hl.window_rule({
	name = "place-personal-msg",
	match = { initial_class = "^(signal)$" },
	workspace = "special:personal-msg silent",
})

hl.window_rule({
	name = "music-auto-style",
	match = { workspace = "special:music" },
	float = true,
	center = true,
	size = { "(monitor_w * 0.7)", "(monitor_h * 0.7)" },
	opacity = "0.9 override 0.1 override 1.0 override", -- active/inactive/fullscreen 三段
})

-- virt-manager:不讓 VM 檢視器接管快捷鍵,保留 Super+數字 切換工作區
hl.window_rule({
	name = "virt-manager-no-shortcuts-inhibit",
	match = { class = "^(virt-manager)$" },
	no_shortcuts_inhibit = true,
})
