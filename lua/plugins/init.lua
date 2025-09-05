return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- Linting support
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")

      -- Check if a file exists in the current working directory
      local function file_exists(file)
        local f = io.open(file, "r")
        if f then
          f:close()
          return true
        end
        return false
      end

      -- Check for project-specific configuration files
      local has_eslint = false
      local eslint_files = {
        '.eslintrc.js', '.eslintrc.cjs', '.eslintrc.yaml',
        '.eslintrc.yml', '.eslintrc.json', '.eslintrc',
        'eslint.config.js', 'eslint.config.mjs'
      }

      for _, file in ipairs(eslint_files) do
        if file_exists(file) then
          has_eslint = true
          break
        end
      end

      -- Check package.json for ESLint dependency
      if not has_eslint and file_exists('package.json') then
        local f = io.open('package.json', "r")
        if f then
          local content = f:read("*all")
          f:close()
          if content:find([["eslint"]]) then
            has_eslint = true
          end
        end
      end

      -- Configure linters based on what's available in the project
      lint.linters_by_ft = {
        javascript = has_eslint and { "eslint_d" } or {},
        javascriptreact = has_eslint and { "eslint_d" } or {},
        typescript = has_eslint and { "eslint_d" } or {},
        typescriptreact = has_eslint and { "eslint_d" } or {},
        vue = has_eslint and { "eslint_d" } or {},
        php = { "phpstan" },
      }

      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })

      vim.keymap.set("n", "<leader>l", function()
        lint.try_lint()
      end, { desc = "Trigger linting for current file" })
    end,
  },
  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
      -- Initialize Vue specific settings
      require "configs.vue".setup()
    end,
  },

  {
    'mrcjkb/rustaceanvim',
    version = '^6', -- Recommended
    lazy = false,   -- This plugin is already lazy
  },

  -- Use blink.cmp for completion (recommended for better performance)
  { import = "nvchad.blink.lazyspec" },

  -- Disable nvim-cmp to prevent conflicts with blink.cmp
  {
    "hrsh7th/nvim-cmp",
    enabled = false,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim", "lua", "vimdoc",
        "html", "css", "javascript", "typescript", "vue", "rust", "toml", "php"
      },
    },
  },

  { 'wakatime/vim-wakatime',         lazy = false },

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

  -- Git blame
  {
    "f-person/git-blame.nvim",
    lazy = true,
    opts = {
      enabled = true
    }
  },

  -- Enhanced Git integration
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gdiffsplit", "Gread", "Gwrite", "Ggrep", "GMove", "GDelete", "GBrowse", "GRemove", "GRename", "Glgrep", "Gedit" }
  },

  -- LazyGit integration
  {
    "kdheepak/lazygit.nvim",
    cmd = "LazyGit",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },

  -- Project management
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup {
        manual_mode = false,
        detection_methods = { "lsp", "pattern" },
        patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "Cargo.toml" },
        ignore_lsp = {},
        exclude_dirs = {},
        show_hidden = false,
        silent_chdir = true,
        scope_chdir = 'global',
        datapath = vim.fn.stdpath("data"),
      }

      -- Load telescope extension
      require('telescope').load_extension('projects')
    end
  },

  -- Session management
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    config = function()
      require("persistence").setup()
    end,
  },

  -- Enhanced file navigation
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()
    end,
  },

  -- Better quickfix window
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    config = function()
      require('bqf').setup()
    end,
  },

  -- Trouble diagnostics
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "Trouble",
    config = function()
      require("trouble").setup()
    end,
  },

  -- Advanced refactoring
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("refactoring").setup()
    end,
  },

  -- Better code actions UI
  {
    "weilbith/nvim-code-action-menu",
    cmd = "CodeActionMenu",
  },

  -- Enhanced text objects
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = "BufReadPost",
  },

  -- Additional text objects
  {
    "wellle/targets.vim",
    event = "BufReadPost",
  },

  -- Surround operations
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end
  },

  -- Multi-cursor editing
  {
    "mg979/vim-visual-multi",
    branch = "master",
    event = "VeryLazy",
    init = function()
      -- Configure vim-visual-multi settings
      vim.g.VM_maps = {
        ["Find Under"] = '<leader>mf',         -- Find word under cursor
        ["Find Subword Under"] = '<leader>mf', -- Find subword under cursor
        ["Select All"] = '<leader>ma',         -- Select all occurrences
        ["Start Regex Search"] = '<leader>mr', -- Start regex search
        ["Add Cursor Down"] = '<leader>mj',    -- Add cursor down
        ["Add Cursor Up"] = '<leader>mk',      -- Add cursor up
        ["Add Cursor At Pos"] = '<leader>mi',  -- Add cursor at position
        ["Select h"] = '<S-Left>',             -- Select left
        ["Select l"] = '<S-Right>',            -- Select right
        ["Select j"] = '<S-Down>',             -- Select down
        ["Select k"] = '<S-Up>',               -- Select up
        ["Skip Region"] = '<leader>mx',        -- Skip current and find next
        ["Remove Region"] = '<leader>mp',      -- Remove current selection
        ["Visual Cursors"] = '<leader>mv',     -- Visual selection to cursors
        ["Visual All"] = '<leader>mA',         -- Select all in visual selection
      }

      -- Disable default mappings that might conflict
      vim.g.VM_default_mappings = 0

      -- Theme settings
      vim.g.VM_theme = 'iceblue'

      -- Show messages
      vim.g.VM_verbose = 0

      -- Enable undo/redo
      vim.g.VM_maps["Undo"] = 'u'
      vim.g.VM_maps["Redo"] = '<C-r>'

      -- Disable VM in specific file types to avoid conflicts
      vim.g.VM_set_statusline = 0
      vim.g.VM_silent_exit = 1

      -- Create autocmd to disable VM in nvim-tree and other file explorers
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "NvimTree", "neo-tree", "oil", "dirvish", "fern" },
        callback = function()
          vim.b.VM_disable = 1
        end,
        desc = "Disable vim-visual-multi in file explorers"
      })
    end,
  },

  {
    "luckasRanarison/tailwind-tools.nvim",
    name = "tailwind-tools",
    build = ":UpdateRemotePlugins",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim", -- optional
      "neovim/nvim-lspconfig",         -- optional
    },
    opts = {}                          -- your configuration
  },

  -- DAP (Debug Adapter Protocol)
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- UI for DAP
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",

      -- Virtual text support
      "theHamsta/nvim-dap-virtual-text",

      -- Mason integration for automatic DAP installation
      "williamboman/mason.nvim",
      "jay-babu/mason-nvim-dap.nvim",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Setup dap-ui
      dapui.setup()

      -- Setup virtual text
      require("nvim-dap-virtual-text").setup()

      -- Setup mason-nvim-dap for automatic adapter installation
      require("mason-nvim-dap").setup({
        ensure_installed = {
          "node2",             -- JavaScript/TypeScript
          "codelldb",          -- Rust/C/C++
          "php-debug-adapter", -- PHP
        },
        automatic_installation = true,
      })

      -- Load DAP configurations
      require("configs.dap")

      -- Automatically open/close dap-ui
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
}
