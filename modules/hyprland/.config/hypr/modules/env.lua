---@diagnostic disable: undefined-global
-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

local home = os.getenv("HOME")
local p = {}
p.mainMod = "SUPER"
p.secMod = "ALT" -- Sets "Alt" key as secondary modifier

p.primaryMonitor = "DP-1"
p.terminal = "ghostty"
p.sec_terminal = "alacritty"
p.browser = "firefox"
p.menu = "walker"
p.workMsg = "vesktop"
p.personalMsg = "signal-desktop"
p.babycam = "byte4work-babycam"
p.fileManager = "GTK_THEME=adw-gtk3-dark thunar"
p.terminalFileManager = p.terminal .. " -e yazi ~/Downloads"
-- p.music = p.terminal .. ' --title="spotify-player" -e spotify_player'
-- p.music = "spotify"
p.music = "spotify-launcher"

local LauncherMenuEntry = {
	Wofi = "byte4work-wofi-entry",
	Walker = "byte4work-walker-entry",
}

local QuickMenuEntry = {
	Wofi = "byte4work-wofi-quick-menu",
	Walker = "byte4work-walker-quick-menu",
}

local PowerMenuEntry = {
	Wofi = "byte4work-wofi-power-menu",
	Walker = "byte4work-walker-power-menu",
}

local EmojiPickerEntry = {
	Wofi = "byte4work-wofi-emojipicker",
	Walker = "byte4work-walker-emojipicker",
}

local ClipboardEntry = {
	Wofi = "byte4work-wofi-clipboard",
	Walker = "byte4work-walker-clipboard",
}

local function get_menu_cmd(entryTable, menuKey, defaultCmd, featureName)
	local cmd = entryTable[menuKey]
	if not cmd then
		local err_msg = string.format(
			"Unsupported menu type '%s' for feature '%s'. Falling back to default.",
			tostring(p.menu),
			featureName
		)
		os.execute(string.format("echo '%s' | byte4work-hyprland-error-notify &", err_msg))
		return defaultCmd
	end
	return cmd
end

local menuKey = p.menu:gsub("^%l", string.upper)
p.launcherCmd = get_menu_cmd(LauncherMenuEntry, menuKey, "byte4work-walker-entry", "Launcher")
p.quickMenuCmd = get_menu_cmd(QuickMenuEntry, menuKey, "byte4work-walker-quick-menu", "Quick Menu")
p.powerMenuCmd = get_menu_cmd(PowerMenuEntry, menuKey, "byte4work-walker-power-menu", "Power Menu")
p.emojiPickerCmd = get_menu_cmd(EmojiPickerEntry, menuKey, "byte4work-walker-symbols", "Emoji Picker")
p.clipboardCmd = get_menu_cmd(ClipboardEntry, menuKey, "byte4work-walker-clipboard", "Clipboard")

hl.env("PRIMARY_MONITOR", p.primaryMonitor)
hl.env("MENU", p.menu)
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.env("HYPRSHOT_DIR", home .. "/Pictures/Screenshots")
hl.env("SCREENSHOT_DIR", home .. "/Pictures/Screenshots")

hl.env("TERMINAL", p.terminal)
hl.env(
	"PATH",
	home
		.. "/.local/bin/wayland:"
		.. home
		.. "/.local/bin/common:"
		.. home
		.. "/.local/bin/hyprland:"
		.. home
		.. "/.local/private/bin:/usr/local/bin:/usr/bin"
)

hl.env("GDK_BACKEND", "wayland")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")

hl.env("mesa_glthread", "true")
-- hl.env("GSK_RENDERER", "nglyph") -- 幫助某些 GTK4 應用穩定
-- hl.env("WLR_RENDERER", "gles2")  -- 如果預設的 vulkan/gles3 噴 EGL 錯誤，可以退回 gles2 測試

return p
