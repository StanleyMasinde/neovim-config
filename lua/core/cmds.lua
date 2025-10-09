local api = vim.api
local themes = { "catppuccin-latte", "catppuccin" }

api.nvim_create_user_command("ToggleTheme", function()
    local current_theme = vim.g.current_theme or themes[1]

    local next_theme = current_theme == themes[1] and themes[2] or themes[1]

    vim.o.background = next_theme == "catppuccin-latte" and "light" or "dark"

    vim.cmd.colorscheme(next_theme)

    vim.g.current_theme = next_theme
end, { desc = "Toggle between themes" })
