-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "ayu_dark",
  theme_toggle = { "ayu_light", "ayu_dark" },
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

return M
