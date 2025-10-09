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
        config = function()
            local current_theme = vim.g.current_theme or 'catppuccin'
            vim.o.background = next_theme == "catppuccin-latte" and "light" or "dark"
            vim.cmd.colorscheme(current_theme)
        end,
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
        'neovim/nvim-lspconfig',
        config = function()
            -- Load Mason integration
            require('mason').setup()
            require('mason-lspconfig').setup({
                ensure_installed = { 'rust_analyzer' },
                automatic_installation = true,
            })

            local lspconfig = require('lspconfig')

            -- Diagnostics visuals
            vim.diagnostic.config({
                virtual_text = true,
                float = { border = 'rounded' },
            })

            -- Shared on_attach: keymaps, etc.
            local on_attach = function(_, bufnr)
                local opts = { buffer = bufnr, silent = true }
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
                vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
            end

            -- Capabilities for Blink or nvim-cmp (we’ll hook blink later)
            local capabilities = vim.lsp.protocol.make_client_capabilities()

            -- rust-analyzer setup
            lspconfig.rust_analyzer.setup({
                on_attach = on_attach,
                capabilities = capabilities,
                settings = {
                    ['rust-analyzer'] = {
                        cargo = { allFeatures = true },
                        checkOnSave = { command = 'clippy' },
                    },
                },
            })
        end
    },
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
