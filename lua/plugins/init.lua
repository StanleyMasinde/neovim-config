local vim = vim

return {
    {
        "stevearc/conform.nvim",
        opts = require "plugins.configs.conform",
    },
    {
        "f-person/git-blame.nvim",
        event = "VeryLazy",
        opts = {
            enabled = true,
            message_template = "<author> • <date> • <summary>",
            date_format = "%r",
            virtual_text_column = 1,
        },
    },
    {
        'goolord/alpha-nvim',
        dependencies = { 'echasnovski/mini.icons' },
        config = function()
            require 'alpha'.setup(require 'alpha.themes.startify'.config)
        end
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim"
        },
        cmd = "Neotree",
        config = function()
            require("plugins.configs.neotree")
        end,
    },

    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("plugins.configs.gitsigns")
        end,
    },
    {
        "rebelot/heirline.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("plugins.configs.heirline")
        end,
    },
    {
        "kdheepak/lazygit.nvim",
        cmd = "LazyGit",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
    },
    { 'wakatime/vim-wakatime',             lazy = false },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("plugins.configs.treesitter")
        end,
    },
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = { "nvim-lua/plenary.nvim" },
        cmd = "Telescope",
        config = function()
            require("plugins.configs.telescope")
        end,
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            require("which-key").setup()
        end,
    },
    { 'williamboman/mason.nvim',           config = true },
    { 'williamboman/mason-lspconfig.nvim', config = true },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("plugins.configs.lsp")
        end,
    },
    {
        'mrcjkb/rustaceanvim',
        version = '^6',
        lazy = false,
    },
    {
        'saecki/crates.nvim',
        tag = 'stable',
        event = { "BufRead Cargo.toml" },
        config = function()
            require('crates').setup({
                completion = {
                    cmp = {
                        enabled = false
                    },
                    crates = {
                        enabled = true,
                        max_results = 8,
                        min_chars = 3,
                    }
                },
                lsp = {
                    enabled = true,
                    on_attach = function(client, bufnr)
                        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
                    end,
                    actions = true,
                    completion = true,
                    hover = true,
                },
            })
        end,
    },
    {
        "saghen/blink.cmp",
        lazy = true,
        event = "InsertEnter",
        dependencies = {
            "rafamadriz/friendly-snippets",
        },
        version = "*",
        opts = {
            keymap = {
                preset = "default",
                ["<CR>"] = { "accept", "fallback" },
                ["<Tab>"] = { "select_next", "fallback" },
                ["<S-Tab>"] = { "select_prev", "fallback" },
            },
            completion = {
                menu = {
                    border = "rounded",
                },
            },
            sources = {
                default = { "lsp", "path", "buffer", "snippets" },
            },
        },
    },
}
