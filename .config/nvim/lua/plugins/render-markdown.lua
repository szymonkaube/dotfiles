return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "Avante" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      local colors = {
        h1     = "#bf616a", -- Red
        h2     = "#ebcb8b", -- Yellow
        h3     = "#a3be8c", -- Green
        h4     = "#b48ead", -- Purple
        h5     = "#8fbcbb", -- Cyan
        h6     = "#81a1c1", -- Blue
        bold   = "#b94676",
        italic = "#38c5a6",
      }

      local bg_colors = {
        h1 = "#474747",
        h2 = "#61543a",
        h3 = "#373737",
        h4 = "#333333",
        h5 = "#272727",
        h6 = "#222222",
      }

      vim.api.nvim_set_hl(0, "ObsidianH1", { fg = colors.h1, bg = bg_colors.h1, bold = true })
      vim.api.nvim_set_hl(0, "ObsidianH2", { fg = colors.h2, bg = bg_colors.h2, bold = true })
      vim.api.nvim_set_hl(0, "ObsidianH3", { fg = colors.h3, bg = bg_colors.h3, bold = true })
      vim.api.nvim_set_hl(0, "ObsidianH4", { fg = colors.h4, bg = bg_colors.h4, bold = true })
      vim.api.nvim_set_hl(0, "ObsidianH5", { fg = colors.h5, bg = bg_colors.h5, bold = true })
      vim.api.nvim_set_hl(0, "ObsidianH6", { fg = colors.h6, bg = bg_colors.h6, bold = true })

      vim.api.nvim_set_hl(0, "@markup.strong", { fg = colors.bold, bold = true })
      vim.api.nvim_set_hl(0, "@markup.italic", { fg = colors.italic, italic = true })


      vim.opt_local.foldmethod = "expr"
      vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.opt_local.foldlevel = 0
      vim.opt_local.breakindent = true

      require("render-markdown").setup({
        heading = {
          enabled = true,
          backgrounds = { 'ObsidianH1', 'ObsidianH2', 'ObsidianH3', 'ObsidianH4', 'ObsidianH5', 'ObsidianH6' },
          icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
        },
        indent = {
          enabled = true,
          per_section = true,
        },
        overrides = {
          buftype = {
            nofile = {
              indent = { enabled = false },
            },
          },
        },
      })
    end,
  }
}
