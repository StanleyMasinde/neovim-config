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
