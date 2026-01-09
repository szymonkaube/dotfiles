vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>') -- exit search highlight upon esc
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>lk', function()
	vim.diagnostic.open_float { desc = 'Display warning message' }
end)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
