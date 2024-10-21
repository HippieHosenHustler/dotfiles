local options = {
	backup = false,
	clipboard = "unnamedplus",
	cmdheight = 2,
	expandtab = true,
	tabstop = 2,
	softtabstop = 2,
	shiftwidth = 2,
	termguicolors = true,
	signcolumn = "yes",
	wrap = false,
	number = true,
	relativenumber = true,
	scrolloff = 8,
	sidescrolloff = 8,
}

for k, v in pairs(options) do
	vim.opt[k] = v
end

vim.g.mapleader = " "
vim.keymap.set("i", "jk", "<esc>")
