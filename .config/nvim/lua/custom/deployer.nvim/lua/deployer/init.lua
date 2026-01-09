local M = {}
local session_password = nil

-- Helper to find the project root (by looking for a .git directory)
local function find_project_root()
  local cwd = vim.fn.getcwd()
  local git_dir = vim.fs.find('.git', { upward = true, type = 'directory', stop = vim.env.HOME })[1]
  if git_dir then
    return vim.fn.fnamemodify(git_dir, ':h')
  end
  return cwd -- Fallback to current working directory
end

-- Helper to parse an ignore file (like .gitignore)
-- It removes comments and blank lines.
local function parse_ignore_file(filepath)
  if vim.fn.filereadable(filepath) ~= 1 then
    return {}
  end

  local lines = vim.fn.readfile(filepath)
  local patterns = {}
  for _, line in ipairs(lines) do
    local trimmed = vim.trim(line)
    if trimmed ~= "" and string.sub(trimmed, 1, 1) ~= "#" then
      table.insert(patterns, trimmed)
    end
  end
  return patterns
end

-- This function is unchanged
local function find_and_load_config()
  -- ... (No changes needed here, copy from your existing file)
  local project_root = vim.fn.getcwd()
  local parent_dir = vim.fn.fnamemodify(project_root, ':h')
  local config_path = parent_dir .. "/rsync_config"

  if vim.fn.filereadable(config_path) ~= 1 then
    return nil, "❌ Config file not found at: " .. config_path
  end

  local ok, config = pcall(dofile, config_path)
  if not ok then
    return nil, "❌ Error loading rsync_config:\n" .. config
  end

  return config, nil
end

function M.clear_password()
  session_password = nil
  vim.notify("✅ Session password has been cleared.", vim.log.levels.INFO)
end

function M.deploy()
  -- The setup part is the same...
  local config, err = find_and_load_config()
  if err then
    vim.notify(err, vim.log.levels.ERROR)
    return
  end
  if not config.ip_address or not config.login or not config.remote_path then
    vim.notify("❌ Config is missing: ip_address, login, remote_path", vim.log.levels.ERROR)
    return
  end
  if session_password == nil then
    local input = vim.fn.inputsecret("🔑 Enter SSH Password for " .. config.login .. "@" .. config.ip_address .. ": ")
    if input == nil or input == "" then
      vim.notify("🛑 Deploy cancelled by user.", vim.log.levels.WARN)
      return
    end
    session_password = input
    vim.notify(" Password stored for this session.", vim.log.levels.INFO)
  end

  -- Building the command is also the same...
  local all_exclude_patterns = {}
  if config.use_gitignore == true then
    local project_root = find_project_root()
    local gitignore_path = project_root .. "/.gitignore"
    local gitignore_patterns = parse_ignore_file(gitignore_path)
    vim.list_extend(all_exclude_patterns, gitignore_patterns)
  end
  if config.exclude and type(config.exclude) == "table" then
    vim.list_extend(all_exclude_patterns, config.exclude)
  end
  if config.protect_remote_paths and type(config.protect_remote_paths) == "table" then
    vim.list_extend(all_exclude_patterns, config.protect_remote_paths)
  end
  local exclude_file_path = nil
  local exclude_from_flag = ""
  if #all_exclude_patterns > 0 then
    exclude_file_path = vim.fn.tempname()
    vim.fn.writefile(all_exclude_patterns, exclude_file_path)
    exclude_from_flag = "--exclude-from='" .. exclude_file_path .. "'"
  end
  local local_path = config.local_path or vim.fn.getcwd()
  if not local_path:find("/$") then
    local_path = local_path .. "/"
  end
  local base_flags = "-avz"
  local perm_flags = "--no-o --no-g --no-perms"
  local delete_flag = ""
  if config.delete_on_remote == true then
    delete_flag = "--delete"
  end
  local cmd_prefix = "sshpass -p '" .. session_password .. "' "
  local cmd = string.format(
    "%srsync %s %s %s %s %s %s %s@%s:%s",
    cmd_prefix,
    base_flags,
    perm_flags,
    delete_flag,
    exclude_from_flag,
    config.extra_flags or "",
    local_path,
    config.login,
    config.ip_address,
    config.remote_path
  )

  -- The Asynchronous Part
  local stdout_chunks = {}
  local stderr_chunks = {}

  vim.notify("🚀 Deploy started in the background...", vim.log.levels.INFO)

  vim.fn.jobstart(cmd, {
    on_stdout = function(_, data)
      -- 'data' is a table of lines. We iterate over it.
      if data then
        for _, line in ipairs(data) do
          if line ~= "" then table.insert(stdout_chunks, line) end
        end
      end
    end,
    on_stderr = function(_, data)
      if data then
        for _, line in ipairs(data) do
          if line ~= "" then table.insert(stderr_chunks, line) end
        end
      end
    end,
    on_exit = function(_, exit_code)
      if exclude_file_path then
        vim.fn.delete(exclude_file_path)
      end

      local stdout_output = table.concat(stdout_chunks, "\n")
      local stderr_output = table.concat(stderr_chunks, "\n")

      vim.schedule(function()
        if exit_code == 0 then
          vim.notify("✅ Deploy successful!", vim.log.levels.INFO)
          if stdout_output ~= "" then print("Rsync Output:\n" .. stdout_output) end
        else
          vim.notify("❌ Deploy failed! Exit code: " .. exit_code, vim.log.levels.ERROR)
          if stderr_output ~= "" then print("Rsync Error:\n" .. stderr_output) end
          if stdout_output ~= "" then print("Rsync Output:\n" .. stdout_output) end
        end
      end)
    end,
  })
end

return M
