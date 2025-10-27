local heirline = require "heirline"
local conditions = require "heirline.conditions"
local utils = require "heirline.utils"

-- Mode highlights
local mode_colors = {
  n = { fg = "#000000", bg = "#9ece6a", bold = true }, -- NORMAL: green
  i = { fg = "#000000", bg = "#7aa2f7", bold = true }, -- INSERT: blue
  v = { fg = "#000000", bg = "#bb9af7", bold = true }, -- VISUAL: purple
  V = { fg = "#000000", bg = "#bb9af7", bold = true }, -- V-LINE
  ["\22"] = { fg = "#000000", bg = "#bb9af7", bold = true }, -- V-BLOCK
  c = { fg = "#000000", bg = "#f7768e", bold = true }, -- COMMAND: red
  R = { fg = "#000000", bg = "#ff9e64", bold = true }, -- REPLACE: orange
  t = { fg = "#000000", bg = "#2ac3de", bold = true }, -- TERMINAL: cyan
}

-- Mode names
local mode_names = {
  n = "NORMAL",
  i = "INSERT",
  v = "VISUAL",
  V = "V-LINE",
  ["\22"] = "V-BLOCK",
  c = "COMMAND",
  R = "REPLACE",
  t = "TERMINAL",
}

local statusline = {
  -- Mode indicator
  {
    provider = function()
      local m = vim.fn.mode()
      local name = mode_names[m] or m
      return " " .. name .. " "
    end,
    hl = function()
      local m = vim.fn.mode()
      return mode_colors[m] or { fg = "white", bg = "black", bold = true }
    end,
  },

  -- File info
  {
    provider = function()
      return " " .. vim.fn.expand "%:t" .. " "
    end,
    hl = { fg = "white", bg = "darkblue" },
  },

  -- Git branch + diff (requires gitsigns)
  {
    condition = conditions.is_git_repo,
    provider = function()
      local gitsigns = vim.b.gitsigns_status_dict or {}
      local branch = gitsigns.head or ""
      local added = gitsigns.added or 0
      local changed = gitsigns.changed or 0
      local removed = gitsigns.removed or 0
      return string.format("  %s (+%d ~%d -%d) ", branch, added, changed, removed)
    end,
    hl = { fg = "yellow", bg = "black" },
  },

  -- LSP diagnostics
  {
    provider = function()
      local diag = vim.diagnostic.get(0)
      local counts = { E = 0, W = 0, H = 0, I = 0 }
      for _, d in ipairs(diag) do
        if d.severity == vim.diagnostic.severity.ERROR then
          counts.E = counts.E + 1
        elseif d.severity == vim.diagnostic.severity.WARN then
          counts.W = counts.W + 1
        elseif d.severity == vim.diagnostic.severity.HINT then
          counts.H = counts.H + 1
        elseif d.severity == vim.diagnostic.severity.INFO then
          counts.I = counts.I + 1
        end
      end
      local parts = {}
      if counts.E > 0 then
        table.insert(parts, "" .. counts.E)
      end
      if counts.W > 0 then
        table.insert(parts, "" .. counts.W)
      end
      if counts.H > 0 then
        table.insert(parts, "" .. counts.H)
      end
      if counts.I > 0 then
        table.insert(parts, "" .. counts.I)
      end
      return table.concat(parts, " ")
    end,
    hl = { fg = "red", bold = true },
  },

  -- Cursor position
  {
    provider = "%l:%c",
    hl = { fg = "white", bg = "black" },
  },
}

heirline.setup {
  statusline = statusline,
  opts = {
    colors = { green = "#9ece6a", darkblue = "#1e1e2e", yellow = "#ffdf5d", red = "#f7768e", white = "#ffffff" },
  },
}
