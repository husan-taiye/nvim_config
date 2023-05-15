local set = vim.o
set.number = true
set.relativenumber = true
set.clipboard = "unnamed"

-- 在copy后高亮
vim.api.nvim_create_autocmd({"TextYankPost"}, {
	pattern = {"*"},
	callback = function()
		vim.highlight.on_yank({
			timeout = 500,
		})
	end,
})

-- keybindings
local opt = { noremap = true, silent = true }
vim.keymap.set("n", "<C-l>", "<C-w>l", opt)
vim.keymap.set("n", "<C-h>", "<C-w>h", opt)
vim.keymap.set("n", "<C-j>", "<C-w>j", opt)
vim.keymap.set("n", "<C-k>", "<C-w>k", opt)