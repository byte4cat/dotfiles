local config_path = os.getenv("HOME") .. "/.local/share/hypr/land/"

_G.myEnv = dofile(config_path .. "env.lua")

dofile(config_path .. "looknfeel.lua")
dofile(config_path .. "cursor.lua")
dofile(config_path .. "input.lua")
dofile(config_path .. "permission.lua")
dofile(config_path .. "wnw.lua") -- Windows and Workspaces
dofile(config_path .. "keybindings.lua")
dofile(config_path .. "autostart.lua")
