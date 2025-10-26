if vim.loader then
    vim.loader.enable()
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("core.options")
require("core.keymaps")
require("core.autocmds")
require("core.cmds")

require("lazy").setup("plugins", {
    ui = { border = "rounded" },
    change_detection = { enabled = true, notify = false },
})

require("catppuccin").setup({
    flavour = "auto",
    background = {
        light = "latte",
        dark = "mocha",
    },
    transparent_background = false,
    float = {
        transparent = false,     -- enable transparent floating windows
        solid = false,           -- use solid styling for floating windows, see |winborder|
    },
    show_end_of_buffer = false,  -- shows the '~' characters after the end of buffers
    term_colors = false,         -- sets terminal colors (e.g. `g:terminal_color_0`)
    dim_inactive = {
        enabled = false,         -- dims the background color of inactive window
        shade = "dark",
        percentage = 0.15,       -- percentage of the shade to apply to the inactive window
    },
    no_italic = false,           -- Force no italic
    no_bold = false,             -- Force no bold
    no_underline = false,        -- Force no underline
    styles = {                   -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = { "italic" }, -- Change the style of comments
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
        -- miscs = {}, -- Uncomment to turn off hard-coded styles
    },
    lsp_styles = { -- Handles the style of specific lsp hl groups (see `:h lsp-highlight`).
        virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
            ok = { "italic" },
        },
        underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
            ok = { "underline" },
        },
        inlay_hints = {
            background = true,
        },
    },
    color_overrides = {},
    custom_highlights = {},
    default_integrations = true,
    auto_integrations = false,
    integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        notify = false,
        mini = {
            enabled = true,
            indentscope_color = "",
        },
        -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
    },
})

-- setup must be called before loading
vim.cmd.colorscheme "catppuccin"


vim.diagnostic.config({
    virtual_text = {
        prefix = "●", -- small dot looks clean
        spacing = 2,
        source = "if_many", -- show source name if multiple
    },
    signs = true,
    underline = true,
    update_in_insert = false, -- don’t spam while typing
    severity_sort = true,
})
