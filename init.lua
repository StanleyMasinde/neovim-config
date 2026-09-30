vim.loader.enable()

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require "core.options"
require "core.keymaps"
require "core.autocmds"
require "core.cmds"

require("lazy").setup("plugins", {
  ui = { border = "rounded" },
  change_detection = { enabled = true, notify = false },
})

require("catppuccin").setup {
  transparent_background = true,
  float = { transparent = true },
  term_colors = true,
  dim_inactive = { enabled = true },
  custom_highlights = function(colors)
    return {
      -- Make inline blame readable while preserving theme palette in both modes.
      GitSignsCurrentLineBlame = { fg = colors.subtext0, bg = "NONE", italic = true },
    }
  end,
  auto_integrations = false,
  integrations = {
    blink_cmp = true,
    gitsigns = true,
    neotree = true,
    telescope = true,
    which_key = true,
    notify = false,
    mason = true,
  },
}

-- Prefer plugin name to avoid clashing with Neovim 0.12's built-in catppuccin
vim.cmd.colorscheme "catppuccin-nvim"

vim.diagnostic.config {
  -- Pick one of virtual_text / virtual_lines (both = double display)
  virtual_text = false,
  virtual_lines = true,
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "󰋇",
      [vim.diagnostic.severity.HINT] = "󰌵",
    },
  },
}
