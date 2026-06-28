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
	size = { "(monitor_w * 0.5)", "(monitor_h * 0.5)" },
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
	match = { class = "^(mpv|vlc|ffplay)$" },
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

hl.window_rule({
	name = "babycam-window",
	match = { initial_title = "BabyCam" },
	monitor = myEnv.primaryMonitor,
	size = { 320, 180 },
	move = { "(monitor_w * 0.87)", "(monitor_h * 0.865)" },
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
	match = { class = "^(spotify)$" },
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
