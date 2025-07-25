require "nvchad.autocmds"

-- Function to detect and apply system theme
local function apply_system_theme()
  local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
  if not handle then
    return
  end

  local result = handle:read("*a")
  handle:close()

  local theme
  if result and result:match("Dark") then
    theme = "onedark"
  else
    theme = "one_light"
  end

  -- Use NvChad's theme switching mechanism
  local present, base46 = pcall(require, "base46")
  if present then
    base46.load_theme(theme)
  end
end

-- Auto-detect system theme on focus events (skip startup since chadrc handles that)
local theme_group = vim.api.nvim_create_augroup("SystemTheme", { clear = true })

vim.api.nvim_create_autocmd("FocusGained", {
  group = theme_group,
  callback = apply_system_theme,
  desc = "Auto-detect system theme on focus"
})

-- Optional: Create a command to manually sync theme
vim.api.nvim_create_user_command("SyncTheme", apply_system_theme, {
  desc = "Sync theme with system appearance"
})

-- Additional useful autocmds
local general_group = vim.api.nvim_create_augroup("GeneralSettings", { clear = true })

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = general_group,
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
  end,
  desc = "Highlight yanked text"
})

-- Auto-resize splits when window is resized
vim.api.nvim_create_autocmd("VimResized", {
  group = general_group,
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
  desc = "Auto-resize splits on window resize"
})

-- Auto-save when losing focus
vim.api.nvim_create_autocmd("FocusLost", {
  group = general_group,
  callback = function()
    vim.cmd("silent! wa")
  end,
  desc = "Auto-save when losing focus"
})

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  group = general_group,
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
  desc = "Remove trailing whitespace on save"
})

-- Close certain filetypes with 'q'
vim.api.nvim_create_autocmd("FileType", {
  group = general_group,
  pattern = { "qf", "help", "man", "lspinfo", "spectre_panel" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
  desc = "Close certain filetypes with 'q'"
})

-- Auto-create directories when saving files
vim.api.nvim_create_autocmd("BufWritePre", {
  group = general_group,
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
  desc = "Auto-create directories when saving files"
})
