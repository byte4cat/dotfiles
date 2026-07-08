---@diagnostic disable: undefined-global
---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = (myEnv and myEnv.mainMod) or "SUPER"
local secMod = (myEnv and myEnv.secMod) or "ALT"

local function sh_exec(cmd)
	return hl.dsp.exec_cmd("sh -c '" .. cmd .. "'")
end

-- ===================
-- 應用程式與視窗操作
-- ===================
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(myEnv.terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("byte4work-wofi-power-menu"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(myEnv.browser))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd(myEnv.emojiPicker))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(myEnv.terminalFileManager))

-- =============
-- 視窗狀態操作
-- =============
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(myEnv.menu .. ' --show drun --prompt "Search Apps"'))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(
	mainMod .. " + SHIFT + R",
	hl.dsp.exec_cmd("pkill glint; pkill swayosd-server; byte4work-launch-waybar & swayosd-server & glint &")
)

-- 視窗輪替與通知控制
hl.bind(mainMod .. " + N", hl.dsp.window.cycle_next({}))
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd("swaync-client -t"))

-- 快捷選單與附加功能
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("byte4work-wofi-quick-menu"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("byte4work-waypaper-theme-switcher"))
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd("byte4work-babycam"))
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("byte4work-hyprland-toggle-pin"))

-- 剪貼簿管理
hl.bind(mainMod .. " + " .. secMod .. " + C", hl.dsp.exec_cmd("byte4work-wofi-clipboard"))

-- ====================
-- 視窗微調 (HJKL 移動與縮放)
-- ====================

-- Resize window
hl.bind(
	mainMod .. " + CONTROL + SHIFT + H",
	hl.dsp.window.resize({ x = -30, y = 0, relative = true }),
	{ repeat_bind = true }
)
hl.bind(
	mainMod .. " + CONTROL + SHIFT + J",
	hl.dsp.window.resize({ x = 0, y = 30, relative = true }),
	{ repeat_bind = true }
)
hl.bind(
	mainMod .. " + CONTROL + SHIFT + K",
	hl.dsp.window.resize({ x = 0, y = -30, relative = true }),
	{ repeat_bind = true }
)
hl.bind(
	mainMod .. " + CONTROL + SHIFT + L",
	hl.dsp.window.resize({ x = 30, y = 0, relative = true }),
	{ repeat_bind = true }
)

-- 移動視窗位置 (Move window)
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))

-- 移動視窗焦點 (Focus) - Vim Style
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

-- ==========================
-- 分組管理 (Group / Tab Mode)
-- ==========================
hl.bind(mainMod .. " + G", function()
	hl.dispatch(hl.dsp.group.toggle())
end)
hl.bind(mainMod .. " + TAB", function()
	hl.dispatch(hl.dsp.group.next())
end)
hl.bind(mainMod .. " + SHIFT + TAB", function()
	hl.dispatch(hl.dsp.group.prev())
end)
hl.bind(mainMod .. " + SHIFT + G", function()
	hl.dispatch(hl.dsp.group.move_out())
end)

-- ====================
-- 工作區管理 (Workspaces)
-- ====================

-- 常規工作區螢幕分配
for i = 1, 9 do
	hl.workspace_rule({ workspace = tostring(i), monitor = myEnv.primaryMonitor })
end
hl.workspace_rule({ workspace = "10", monitor = "HDMI-A-1" })

-- 動態創建 Special Workspaces 的空白預設
hl.workspace_rule({
	workspace = "special:scratchpad-term",
	on_created_empty = myEnv.terminal .. " -e bash -c 'tmux new-session -A -s scratchpad; exec bash'",
})
hl.workspace_rule({ workspace = "special:music", on_created_empty = "[float] " .. myEnv.music })
hl.workspace_rule({ workspace = "special:work-msg", on_created_empty = "[tiled] " .. myEnv.workMsg })
hl.workspace_rule({ workspace = "special:temp" })

-- 常規 1-10 快捷鍵綁定
for i = 1, 10 do
	local key = i % 10
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- 啟用工作區循環相容
hl.config({ binds = { allow_workspace_cycles = true } })
hl.bind(mainMod .. " + GRAVE", function()
	hl.dispatch(hl.dsp.workspace.focus("previous"))
end)

-- =====================
-- 特殊工作區 (Special)
-- =====================

hl.bind(myEnv.mainMod .. " + S", hl.dsp.workspace.toggle_special("work-msg"))
hl.bind(myEnv.mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:work-msg" }))

hl.bind(myEnv.mainMod .. " + V", function()
	hl.dispatch(hl.dsp.focus({ monitor = myEnv.primaryMonitor }))
	hl.dispatch(hl.dsp.workspace.toggle_special("music"))
end)

hl.bind(myEnv.mainMod .. " + X", hl.dsp.workspace.toggle_special("personal-msg"))
hl.bind(myEnv.mainMod .. " + SHIFT + X", hl.dsp.window.move({ workspace = "special:personal-msg" }))

hl.bind(myEnv.mainMod .. " + A", function()
	hl.dispatch(hl.dsp.focus({ monitor = myEnv.primaryMonitor }))
	hl.dispatch(hl.dsp.workspace.toggle_special("scratchpad-term"))
end)

hl.bind(myEnv.mainMod .. " + O", hl.dsp.workspace.toggle_special("temp"))
hl.bind(myEnv.mainMod .. " + SHIFT + O", hl.dsp.window.move({ workspace = "special:temp" }))

-- =========
-- 滑鼠綁定
-- =========
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(mainMod .. " + mouse_up", hl.dsp.exec_cmd("hyprctl keyword cursor:zoom_factor 0.8"))
hl.bind(mainMod .. " + mouse_down", hl.dsp.exec_cmd("hyprctl keyword cursor:zoom_factor 1.2"))

-- ===========
-- SCREENSHOT
-- ===========
local screenshot_dir = os.getenv("HOME") .. "/Pictures/Screenshots"

local notify_cmd = "notify-send 'Screenshot' \"saved & copied\""
local cmd_full = "grim - | tee " .. screenshot_dir .. "/$(date +'%Y%m%d-%H%M%S').png | wl-copy && " .. notify_cmd
local cmd_slurp = 'grim -g "$(slurp)" - | tee '
	.. screenshot_dir
	.. "/$(date +'%Y%m%d-%H%M%S').png | wl-copy && "
	.. notify_cmd

hl.bind(mainMod .. " + CONTROL + 1", sh_exec(cmd_full))
hl.bind(mainMod .. " + CONTROL + 2", sh_exec(cmd_slurp))
hl.bind(mainMod .. " + CONTROL + 3", sh_exec(cmd_slurp))

local satty_full = "grim - | satty --filename - --fullscreen --output-filename "
	.. screenshot_dir
	.. "/$(date +'%Y%m%d-%H%M%S').png"
local satty_slurp = 'grim -g "$(slurp)" - | satty --filename - --output-filename '
	.. screenshot_dir
	.. "/$(date +'%Y%m%d-%H%M%S').png"

hl.bind(mainMod .. " + CONTROL + SHIFT + 1", sh_exec(satty_full))
hl.bind(mainMod .. " + CONTROL + SHIFT + 2", sh_exec(satty_slurp))
hl.bind(mainMod .. " + CONTROL + SHIFT + 3", sh_exec(satty_slurp))

-- =====
-- ZOOM
-- =====

local function adjust_zoom(factor)
	hl.config({ cursor = { zoom_factor = factor } })
end

local current_zoom = 1.0
local function apply_zoom(multiplier)
	current_zoom = math.max(1.0, math.min(5.0, current_zoom * multiplier))
	adjust_zoom(current_zoom)
end

hl.bind(mainMod .. " + equal", function()
	apply_zoom(1.1)
end, { repeating = true })

hl.bind(mainMod .. " + minus", function()
	apply_zoom(0.9)
end, { repeating = true })

-- Reset
hl.bind(mainMod .. " + SHIFT + 0", function()
	current_zoom = 1.0
	adjust_zoom(1.0)
end)

-- 滑鼠滾輪綁定
hl.bind(mainMod .. " + mouse_up", function()
	apply_zoom(0.9)
end)
hl.bind(mainMod .. " + mouse_down", function()
	apply_zoom(1.1)
end)

-- =====================
-- MULTIMEDIA & SWAYOSD
-- =====================

local function swayosd_exec(action_arg)
	local target_cmd = string.format(
		"swayosd-client --monitor \"$(hyprctl monitors -j | jq -r '.[] | select(.focused == true).name')\" %s",
		action_arg
	)
	return target_cmd
end

local vol_up_cmd = "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+; " .. swayosd_exec("--output-volume raise")
local vol_down_cmd = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-; " .. swayosd_exec("--output-volume lower")
local vol_mute_cmd = swayosd_exec("--output-volume mute-toggle")
local mic_mute_cmd = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle; " .. swayosd_exec("--input-volume mute-toggle")

-- 筆電/標準多媒體鍵
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(vol_up_cmd), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(vol_down_cmd), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(vol_mute_cmd), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(mic_mute_cmd), { locked = true })

-- Volum control
hl.bind(mainMod .. " + bracketright", hl.dsp.exec_cmd(vol_up_cmd), { locked = true, repeating = true })
hl.bind(mainMod .. " + bracketleft", hl.dsp.exec_cmd(vol_down_cmd), { locked = true, repeating = true })
hl.bind(mainMod .. " + backslash", hl.dsp.exec_cmd(vol_mute_cmd), { locked = true, repeating = true })

-- 亮度控制
local br_up_cmd = "brightnessctl -e4 -n2 set 5%+; " .. swayosd_exec("--brightness up")
local br_down_cmd = "brightnessctl -e4 -n2 set 5%-; " .. swayosd_exec("--brightness down")

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(br_up_cmd), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(br_down_cmd), { locked = true, repeating = true })

-- Playerctl 串流控制
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
