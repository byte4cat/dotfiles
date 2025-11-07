-- disable netrw at the very start of your init.lua for nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.mapleader = " "
vim.g.encoding = "utf-8"

vim.opt.number = true
vim.opt.relativenumber = true

vim.o.termguicolors = true

vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

vim.opt.scrolloff = 20
vim.opt.cursorline = true
vim.opt.updatetime = 50
vim.opt.colorcolumn = "80"

-- vim.opt.listchars:append("eol:↲")

vim.opt.foldmethod = "indent"
vim.opt.foldenable = false

vim.opt.clipboard = "unnamedplus"

local is_mac = vim.fn.has("macunix") == 1
local is_linux = vim.fn.has("unix") == 1 and not is_mac

-- Helper function to check if running on Wayland
local function is_wayland()
	-- os.getenv returns nil if the variable is not found
	return os.getenv("WAYLAND_DISPLAY") ~= nil
end

if is_mac then
	-- macOS uses pbcopy/pbpaste
	vim.g.clipboard = {
		name = "macOS-clipboard",
		copy = {
			["+"] = "pbcopy",
			["*"] = "pbcopy",
		},
		paste = {
			["+"] = "pbpaste",
			["*"] = "pbpaste",
		},
		cache_enabled = 0,
	}
elseif is_linux then
	if is_wayland() then
		-- Linux with Wayland uses wl-copy/wl-paste
		vim.g.clipboard = {
			name = "wayland-clipboard",
			copy = {
				["+"] = "wl-copy",
				["*"] = "wl-copy",
			},
			paste = {
				["+"] = "wl-paste",
				["*"] = "wl-paste",
			},
			cache_enabled = 0,
		}
	else
		-- Linux with X11 uses xclip
		vim.g.clipboard = {
			name = "x11-clipboard",
			copy = {
				["+"] = "xclip -selection clipboard",
				["*"] = "xclip -selection clipboard",
			},
			paste = {
				["+"] = "xclip -selection clipboard -o",
				["*"] = "xclip -selection clipboard -o",
			},
			cache_enabled = 0,
		}
	end
end
