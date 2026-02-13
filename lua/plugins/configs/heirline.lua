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

local function get_hl_bg(group, fallback)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
  if ok and hl and hl.bg then
    return string.format("#%06x", hl.bg)
  end
  return fallback
end

local function hex_to_rgb(hex)
  local h = hex:gsub("#", "")
  return tonumber(h:sub(1, 2), 16), tonumber(h:sub(3, 4), 16), tonumber(h:sub(5, 6), 16)
end

local function relative_luminance(hex)
  local r, g, b = hex_to_rgb(hex)
  local function channel(c)
    c = c / 255
    if c <= 0.03928 then
      return c / 12.92
    end
    return ((c + 0.055) / 1.055) ^ 2.4
  end
  return 0.2126 * channel(r) + 0.7152 * channel(g) + 0.0722 * channel(b)
end

local function readable_fg(bg_hex)
  local l = relative_luminance(bg_hex)
  local black_contrast = (l + 0.05) / 0.05
  local white_contrast = 1.05 / (l + 0.05)
  return black_contrast >= white_contrast and "#11111b" or "#eff1f5"
end

local function statusline_fallbacks()
  if vim.o.background == "dark" then
    return { fg = "#cdd6f4", bg = "#313244" }
  end
  return { fg = "#4c4f69", bg = "#ccd0da" }
end

local function statusline_hl()
  local fb = statusline_fallbacks()
  return {
    fg = get_hl_fg("StatusLine", fb.fg),
    bg = get_hl_bg("StatusLine", fb.bg),
  }
end

local function git_icon()
  return ""
end

local Diagnostics = {

  condition = conditions.has_diagnostics,
  hl = statusline_hl,
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
      return { fg = get_hl_fg("DiagnosticError", "#d20f39") }
    end,
  },
  {
    provider = function(self)
      return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
    end,
    hl = function()
      return { fg = get_hl_fg("DiagnosticWarn", "#df8e1d") }
    end,
  },
  {
    provider = function(self)
      return self.info > 0 and (self.info_icon .. self.info .. " ")
    end,
    hl = function()
      return { fg = get_hl_fg("DiagnosticInfo", "#1e66f5") }
    end,
  },
  {
    provider = function(self)
      return self.hints > 0 and (self.hint_icon .. self.hints)
    end,
    hl = function()
      return { fg = get_hl_fg("DiagnosticHint", "#179299") }
    end,
  },
  {
    provider = "]",
  },
}

-- Mode highlights
local mode_bg = {
  n = "#9ece6a", -- NORMAL: green
  i = "#7aa2f7", -- INSERT: blue
  v = "#bb9af7", -- VISUAL: purple
  V = "#bb9af7", -- V-LINE
  ["\22"] = "#bb9af7", -- V-BLOCK
  c = "#f7768e", -- COMMAND: red
  R = "#ff9e64", -- REPLACE: orange
  t = "#2ac3de", -- TERMINAL: cyan
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
      local bg = mode_bg[m]
      if not bg then
        local hl = statusline_hl()
        hl.bold = true
        return hl
      end
      return { fg = readable_fg(bg), bg = bg, bold = true }
    end,
  },

  -- File info
  {
    provider = function()
      return " " .. vim.fn.expand "%:t" .. " "
    end,
    hl = statusline_hl,
  },

  -- Git branch + diff (requires gitsigns)
  {
    condition = conditions.is_git_repo,
    init = function(self)
      local gitsigns = vim.b.gitsigns_status_dict or {}
      self.branch = gitsigns.head or ""
      self.added = gitsigns.added or 0
      self.changed = gitsigns.changed or 0
      self.removed = gitsigns.removed or 0
    end,
    {
      provider = function(self)
        return string.format(" %s %s(", git_icon(), self.branch)
      end,
      hl = statusline_hl,
    },
    {
      provider = function(self)
        return "+" .. self.added
      end,
      hl = function()
        local base = statusline_hl()
        return { fg = get_hl_fg("DiffAdd", "#40a02b"), bg = base.bg }
      end,
    },
    {
      provider = function(self)
        return "-" .. self.removed
      end,
      hl = function()
        local base = statusline_hl()
        return { fg = get_hl_fg("DiffDelete", "#d20f39"), bg = base.bg }
      end,
    },
    {
      provider = function(self)
        return "~" .. self.changed
      end,
      hl = function()
        local base = statusline_hl()
        return { fg = get_hl_fg("DiffChange", "#df8e1d"), bg = base.bg }
      end,
    },
    {
      provider = ") ",
      hl = statusline_hl,
    },
  },

  -- LSP diagnostics
  Diagnostics,

  -- Right align everything after this point
  {
    provider = "%=",
    hl = statusline_hl,
  },

  -- Cursor position (far right)
  {
    provider = "%l:%c ",
    hl = statusline_hl,
  },
}

heirline.setup {
  statusline = statusline,
}
