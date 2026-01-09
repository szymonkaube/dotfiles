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
          path = "~/personal/git_baza"
        }
      },

      new_notes_location = "notes_subdir",
      notes_subdir = "001 Inbox",

      -- render-markdown handles markdown rendering
      ui = { enable = false },

      follow_img_func = function(img)
        if vim.v.shell_error == 0 then
          local win_path = string.gsub(vim.fn.system({ 'wslpath', '-w', img }), '\n', '')
          vim.fn.jobstart({ 'cmd.exe', '/C', 'start', '""', win_path })
        else
          vim.fn.jobstart({ "xdg-open", img })
        end
      end,

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
