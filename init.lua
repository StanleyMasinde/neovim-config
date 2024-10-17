-- Set global variables for paths and leader key
vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader = " "

-- Path for lazy.nvim
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

-- Bootstrap lazy.nvim if not installed
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  -- NvChad for base configuration and UI
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { "nvim-neotest/nvim-nio" },

  {
    "neovim/nvim-lspconfig",
  },
  {
    "hrsh7th/nvim-cmp", -- Completion plugin
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp
    },
  },

  -- Git blame
  { "f-person/git-blame.nvim", lazy = true },

  -- TailwindCss
  { "luckasRanarison/tailwind-tools.nvim" },

  -- Time tracking
  { "wakatime/vim-wakatime", lazy = false },
  -- Rust development
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    lazy = false,
    config = function()
      local mason_registry = require "mason-registry"
      local codelldb = mason_registry.get_package "codelldb"
      if not codelldb then
        print "codelldb not installed. Please install it via Mason."
        return
      end

      local extension_path = codelldb:get_install_path() .. "/extension/"
      local codelldb_path = extension_path .. "adapter/codelldb"
      local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib" -- Adjust for non-macOS systems

      vim.g.rustaceanvim = {
        dap = {
          adapter = require("rustaceanvim.config").get_codelldb_adapter(codelldb_path, liblldb_path),
        },
      }
    end,
  },
  -- Rust.vim for additional Rust support
  {
    "rust-lang/rust.vim",
    ft = "rust",
    init = function()
      vim.g.rustfmt_autosave = 1
    end,
  },
  -- Debugging tools
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap, dapui = require "dap", require "dapui"
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
  -- Mason for managing LSP servers, DAP adapters, etc.
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
  },
  -- DAP UI
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("dapui").setup()
    end,
  },

  -- Import additional plugins
  { import = "plugins" },
}, {
  -- Here you would put your lazy_config if you have one, or you can leave this empty
})

-- Setup Mason after it's been loaded by lazy.nvim
require("mason").setup()

-- Git blame
require("gitblame").setup {}

-- ESLint
require("lspconfig").eslint.setup {}

-- Ts language server
require("lspconfig").ts_ls.setup {
  init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = "/usr/local/lib/node_modules/@vue/typescript-plugin",
        languages = { "javascript", "typescript", "vue" },
      },
    },
  },
  filetypes = {
    "javascript",
    "typescript",
    "vue",
  },
}

-- PHP
require("lspconfig").phpactor.setup {
  dependencies = {
    "nvim-lua/plenary.nvim",
    "neovim/nvim-lspconfig"
  }
}

-- YAML
require("lspconfig").yamlls.setup {}

-- Volar
require("lspconfig").volar.setup {
  filetypes = { "typescript", "javascript", "vue", "json" },
}

-- You must make sure volar is setup
-- e.g. require'lspconfig'.volar.setup{}
-- See volar's section for more information

-- Load NvChad theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

-- Load additional configurations
require "options"
require "nvchad.autocmds"

-- Schedule mappings to be loaded last for better performance
vim.schedule(function()
  require "mappings"
end)
