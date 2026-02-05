return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          vim.bo[args.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

          local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
          -- Auto-format ("lint") on keybind.
          if not client:supports_method('textDocument/willSaveWaitUntil')
              and client:supports_method('textDocument/formatting') then
            vim.keymap.set('n', '<leader>f', function()
              vim.lsp.buf.format({ async = true, bufnr = args.buf })
              vim.notify("Formatted buffer " .. args.buf, vim.log.levels.INFO)
            end, {
              buffer = args.buf,
              noremap = true,
              silent = true,
              desc = "Format current buffer with LSP"
            })
            -- Auto-format ("lint") on save.
            -- vim.api.nvim_create_autocmd('BufWritePre', {
            --   group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
            --   buffer = args.buf,
            --   callback = function()
            --     vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
            --   end,
            -- })
          end

          -- LSP keymaps
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = args.buf, desc = 'LSP: ' .. desc })
          end
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('gr', function()
            require('telescope.builtin').lsp_references({
              path_display = { 'smart' }
            })
          end, '[G]oto [R]eferences')
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        end,
      })

      -- make .phtml filetypes be recognized as phtml and not php
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = "*.phtml",
        callback = function()
          vim.bo.filetype = "phtml"
        end,
      })

      local servers = {
        'lua_ls',
        'ts_ls',
        'phpactor',
        'eslint',
        'html',
        'pylsp'
      }

      require('mason').setup()
      require('mason-lspconfig').setup({
        ensure_installed = servers,
      })
    end,
  },
}
