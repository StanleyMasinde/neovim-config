local api = vim.api
local modes = { "light", "dark" }

local function detect_system_theme()
  if vim.loop.os_uname().sysname ~= "Darwin" then
    return nil
  end

  local output = vim.fn.system("defaults read -g AppleInterfaceStyle 2>/dev/null")
  if vim.v.shell_error == 0 and output:match "Dark" then
    return "dark"
  end

  return "light"
end

api.nvim_create_user_command("ToggleTheme", function()
  local current_mode = vim.o.background or modes[1]

  vim.o.background = current_mode == "light" and "dark" or "light"
end, { desc = "Toggle between themes" })

api.nvim_create_user_command("SyncTheme", function()
  local mode = detect_system_theme()
  if not mode then
    vim.notify("SyncTheme is only implemented for macOS", vim.log.levels.WARN)
    return
  end

  vim.o.background = mode
end, { desc = "Sync Neovim theme with system appearance" })
