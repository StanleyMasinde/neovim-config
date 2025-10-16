local api = vim.api
local modes = { "light", "dark" }

api.nvim_create_user_command("ToggleTheme", function()
    local current_mode = vim.o.background or modes[1]


    vim.o.background = current_mode == "light" and "dark" or "light"
end, { desc = "Toggle between themes" })
