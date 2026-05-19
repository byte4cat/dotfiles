-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

local home = os.getenv("HOME")
local p = {}
p.mainMod = "SUPER"
p.altMod = "ALT" -- Sets "Alt" key as secondary modifier

p.primaryMonitor = "DP-1"

p.terminal = "ghostty"
p.browser = "librewolf"
p.menu = "byte4work-walker"
p.workMsg = "vesktop"
p.personalMsg = "signal-desktop"
p.babycam = "byte4work-babycam"
p.fileManager = "GTK_THEME=adw-gtk3-dark thunar"
p.terminalFileManager = p.terminal .. " -e yazi ~/Downloads"
p.music = p.terminal .. ' --title="spotify-player" -e spotify_player'

hl.env("PRIMARY_MONITOR", "DP-1")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.env("HYPRSHOT_DIR", home .. "/Pictures/Screenshots")

hl.env("TERMINAL", p.terminal)
hl.env("PATH", home .. "/.local/bin/wayland:" .. home .. "/.local/private/bin:/usr/local/bin:/usr/bin")

hl.env("GDK_BACKEND", "wayland")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")

hl.env("mesa_glthread", "true")
-- hl.env("GSK_RENDERER", "nglyph") -- 幫助某些 GTK4 應用穩定
-- hl.env("WLR_RENDERER", "gles2")  -- 如果預設的 vulkan/gles3 噴 EGL 錯誤，可以退回 gles2 測試

return p
