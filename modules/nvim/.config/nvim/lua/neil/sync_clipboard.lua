local is_ssh = os.getenv("SSH_TTY") ~= nil or os.getenv("SSH_CONNECTION") ~= nil
local session_type = os.getenv("XDG_SESSION_TYPE")

if is_ssh or os.getenv("TMUX") then
	-- Remote Tmux, OSC 52
	vim.g.clipboard = "osc52"
elseif session_type == "wayland" then
	-- Local Wayland
	vim.g.clipboard = {
		name = "Wayland-Local",
		copy = {
			["+"] = "wl-copy",
			["*"] = "wl-copy",
		},
		paste = {
			["+"] = "wl-paste --no-newline",
			["*"] = "wl-paste --no-newline",
		},
		cache_enabled = 1,
	}
elseif session_type == "x11" then
	-- Local X11
	vim.g.clipboard = {
		name = "X11-Local",
		copy = {
			["+"] = "xclip -selection clipboard",
			["*"] = "xclip -selection primary",
		},
		paste = {
			["+"] = "xclip -selection clipboard -o",
			["*"] = "xclip -selection primary -o",
		},
		cache_enabled = 1,
	}
end

-- Sync
vim.opt.clipboard = "unnamedplus"
