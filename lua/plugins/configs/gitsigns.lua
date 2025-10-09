local gitsigns = require("gitsigns")

gitsigns.setup({
    signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
    },
    numhl = false,
    linehl = false,
    keymaps = {
        -- Navigation
        { mode = "n", ["]c"] = { expr = true, "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'" } },
        { mode = "n", ["[c"] = { expr = true, "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'" } },
    },
    watch_gitdir = { interval = 1000 },
    attach_to_untracked = true,
    current_line_blame = false,
})
