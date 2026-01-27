return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    ft = "markdown",
    ---@module 'obsidian'
    ---@type obsidian.config
    opts = {
      legacy_commands = false,
      workspaces = {
        {
          name = "personal",
          path = "~/personal/obsidian"
        }
      },

      callbacks = {
        enter_note = function(self, note)
          -- overwrite <leader>sf to use Obsidian's alias-aware search
          vim.keymap.set("n", "<leader>sf", "<cmd>Obsidian search<cr>", {
            buffer = true,
            desc = "Obsidian Search (includes Aliases)",
          })

          -- map 'smart_action' to something handy
          vim.keymap.set("n", "<cr>", function()
            return require("obsidian").util.smart_action()
          end, { buffer = true, expr = true })
        end,
      },

      new_notes_location = "notes_subdir",
      notes_subdir = "001 Inbox",

      -- render-markdown handles markdown rendering
      ui = { enable = false },

      -- open image from link (wsl)
      follow_img_func = function(img)
        if vim.v.shell_error == 0 then
          local win_path = string.gsub(vim.fn.system({ 'wslpath', '-w', img }), '\n', '')
          vim.fn.jobstart({ 'cmd.exe', '/C', 'start', '""', win_path })
        else
          vim.fn.jobstart({ "xdg-open", img })
        end
      end,

      -- note ids are file names
      note_id_func = function(title)
        local suffix = ""
        if title ~= nil then
          return title
        else
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
          return tostring(os.time()) .. "-" .. suffix
        end
      end,
    },
  }
}
