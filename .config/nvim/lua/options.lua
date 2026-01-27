vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.winborder = 'rounded'
vim.opt.mouse = 'a'
vim.opt.expandtab = true -- use spaces instead of tabs
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.showmode = false -- show vim mode in status bar
vim.opt.colorcolumn = '80'
vim.opt.breakindent = true
-- case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
-- decrease some wait times
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
-- define how splits should work
vim.opt.splitright = true
vim.opt.splitbelow = true
-- sets how neovim will display certain whitespace characters in the editor
-- vim.opt.list = true
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
-- show preview when doing substitution (:%s/)
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
-- minimal number of screen lines to keep above and below the cursor
vim.opt.scrolloff = 10
vim.opt.conceallevel = 2

-- block cursor in insert mode
vim.opt.guicursor = "i:block"

vim.opt.termguicolors = true
vim.diagnostic.config({
  float = {
    border = "rounded",
  }
})

-- sync OS clipboard with neovim clipboard
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

vim.api.nvim_create_autocmd("FileType", {
  pattern = "php",
  callback = function()
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
    vim.bo.softtabstop = 4
    vim.bo.expandtab = true
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "javascript",
  callback = function()
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.bo.softtabstop = 2
    vim.bo.expandtab = true
  end,
})
