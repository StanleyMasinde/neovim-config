local heirline = require("heirline")
local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

local statusline = {
    -- Mode indicator
    {
        provider = function()
            local mode = vim.fn.mode()
            return " " .. mode .. " "
        end,
        hl = { fg = "black", bg = "green", bold = true },
    },

    -- File info
    {
        provider = function()
            return " " .. vim.fn.expand("%:t") .. " "
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
            return string.format("  %s +%d ~%d -%d ", branch, added, changed, removed)
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
            if counts.E > 0 then table.insert(parts, "" .. counts.E) end
            if counts.W > 0 then table.insert(parts, "" .. counts.W) end
            if counts.H > 0 then table.insert(parts, "" .. counts.H) end
            if counts.I > 0 then table.insert(parts, "" .. counts.I) end
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

heirline.setup({
    statusline = statusline,
    opts = { colors = { green = "#9ece6a", darkblue = "#1e1e2e", yellow = "#ffdf5d", red = "#f7768e", white = "#ffffff" } }
})
