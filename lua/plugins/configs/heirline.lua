local heirline = require "heirline"
local conditions = require "heirline.conditions"

local default_diag_icons = {
  [vim.diagnostic.severity.ERROR] = "E",
  [vim.diagnostic.severity.WARN] = "W",
  [vim.diagnostic.severity.INFO] = "I",
  [vim.diagnostic.severity.HINT] = "H",
}

local function get_diag_icon(severity)
  local cfg = vim.diagnostic.config() or {}
  local signs = cfg.signs or {}
  local text = signs.text or {}
  return text[severity] or default_diag_icons[severity]
end

local function get_hl_fg(group, fallback)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
  if ok and hl and hl.fg then
    return string.format("#%06x", hl.fg)
  end
  return fallback
end

local Diagnostics = {

  condition = conditions.has_diagnostics,
  init = function(self)
    self.error_icon = get_diag_icon(vim.diagnostic.severity.ERROR)
    self.warn_icon = get_diag_icon(vim.diagnostic.severity.WARN)
    self.info_icon = get_diag_icon(vim.diagnostic.severity.INFO)
    self.hint_icon = get_diag_icon(vim.diagnostic.severity.HINT)

    self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
    self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
  end,

  update = { "DiagnosticChanged", "BufEnter" },

  {
    provider = "![",
  },
  {
    provider = function(self)
      return self.errors > 0 and (self.error_icon .. self.errors .. " ")
    end,
    hl = function()
      return { fg = get_hl_fg("DiagnosticError", "#f7768e") }
    end,
  },
  {
    provider = function(self)
      return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
    end,
    hl = function()
      return { fg = get_hl_fg("DiagnosticWarn", "#ffdf5d") }
    end,
  },
  {
    provider = function(self)
      return self.info > 0 and (self.info_icon .. self.info .. " ")
    end,
    hl = function()
      return { fg = get_hl_fg("DiagnosticInfo", "#2ac3de") }
    end,
  },
  {
    provider = function(self)
      return self.hints > 0 and (self.hint_icon .. self.hints)
    end,
    hl = function()
      return { fg = get_hl_fg("DiagnosticHint", "#7aa2f7") }
    end,
  },
  {
    provider = "]",
  },
}

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

  -- Cursor position
  {
    provider = "%l:%c ",
    hl = { fg = "white", bg = "black" },
  },

  -- LSP diagnostics
  Diagnostics,
}

heirline.setup {
  statusline = statusline,
  opts = {
    colors = { green = "#9ece6a", darkblue = "#1e1e2e", yellow = "#ffdf5d", red = "#f7768e", white = "#ffffff" },
  },
}
