return {
  {
    'vague2k/vague.nvim',
    config = function()
      require('vague').setup {
        transparent = true,
        style = {
          comments = 'none',
          strings = 'none',
          keyword_return = 'none',
        },
      }
      vim.cmd 'colorscheme vague'

      -- Active statusline
      vim.api.nvim_set_hl(0, "StatusLine", {
        fg = "#cdcdcd",
        bg = "#5e5e88",
      })
      -- Inactive statuslines
      vim.api.nvim_set_hl(0, "StatusLineNC", {
        fg = "#808080",
        bg = "#141415",
      })
    end
  },
}
