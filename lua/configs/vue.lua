-- Vue.js configuration for better IntelliSense and integration

local M = {}

-- Setup function for vue integration
function M.setup()
  -- Check for Volar language server in a more compatible way
  local function check_volar_installed()
    local handle = io.popen("ls -l " ..
    os.getenv("HOME") .. "/.local/share/nvim/mason/packages/vue-language-server 2>/dev/null")
    local result = ""
    if handle then
      result = handle:read("*a") or ""
      handle:close()
    end
    return result ~= ""
  end

  local has_volar = check_volar_installed()

  if not has_volar then
    print("Vue Language Server not installed. For better Vue support, run :MasonInstall vue-language-server")
    return
  end

  -- Set up Treesitter for Vue files
  local ts_ok, ts = pcall(require, "nvim-treesitter.configs")
  if ts_ok then
    -- Ensure Vue syntax is supported
    ts.setup {
      ensure_installed = { "vue" },
      highlight = { enable = true },
    }
  end

  -- Set up filetype detection for Vue
  vim.filetype.add({
    extension = {
      vue = "vue",
    },
  })

  -- Setup LSP keybindings for Vue files
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "vue",
    callback = function()
      -- Map common LSP functions for Vue files
      local opts = { noremap = true, silent = true, buffer = true }
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    end
  })

  -- Configure Vue snippet support
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "vue",
    callback = function()
      -- Set up Vue-specific completions
      vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"

      -- Allow Emmet expansion in Vue files
      vim.b.emmet_settings = {
        javascript = { extends = 'jsx' },
        typescript = { extends = 'tsx' },
        vue = { extends = 'html' },
      }
    end
  })
end

return M
