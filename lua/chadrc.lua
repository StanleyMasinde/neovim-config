-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@class ChadrcConfig
local M = {}

-- Function to detect system theme on macOS
local function get_system_theme()
  local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
  if not handle then
    return "vscode_light" -- Default to light theme if command fails
  end

  local result = handle:read("*l")
  handle:close()

  -- If AppleInterfaceStyle is "Dark", system is in dark mode
  -- If the command fails or returns empty, system is in light mode
  if result and result:match("Dark") then
    return "vscode_dark"
  else
    return "vscode_light"
  end
end

M.base46 = {
  theme = get_system_theme(),
  theme_toggle = { "vscode_dark", "vscode_light" },
  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
  },
}

M.ui = {
  telescope = {
    style = "bordered",
  },
  statusline = {
    theme = "default",
    separator_style = "round",
  },
  tabufline = {
    lazyload = false,
  },
}

M.nvdash = {
  load_on_startup = true,

  header = {
    "Stanley Masinde",
    "AKA John Doe",
    "",
    "John Doe",
    "",
    "",
  },
}

return M
