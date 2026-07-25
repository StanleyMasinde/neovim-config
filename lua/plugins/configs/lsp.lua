-- Vue language server plugin path (Mason v2 layout).
local vue_language_server_path = vim.fn.expand "$MASON/packages"
  .. "/vue-language-server"
  .. "/node_modules/@vue/language-server"

local tsserver_filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" }
local vue_plugin = {
  name = "@vue/typescript-plugin",
  location = vue_language_server_path,
  languages = { "vue" },
  configNamespace = "typescript",
}

-- Prefer ts_ls: it is what Mason installs (typescript-language-server).
-- Wire the Vue TS plugin so .vue SFCs get proper TS support.
vim.lsp.config("ts_ls", {
  init_options = {
    plugins = {
      vue_plugin,
    },
  },
  filetypes = tsserver_filetypes,
})

vim.lsp.config("vue_ls", {})

vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      diagnostics = {
        enable = true,
      },
    },
  },
})

-- Explicit enable list only (mason-lspconfig automatic_enable is off).
-- One server per role: intelephense (not phpactor), emmet_language_server (not emmet_ls),
-- ts_ls (Mason's typescript-language-server; not vtsls).
-- Add servers here after :MasonInstall, or install lua_ls / jsonls if you want them.
vim.lsp.enable {
  "ts_ls",
  "vue_ls",
  "rust_analyzer", -- install via OS package manager (see README)
  "bashls",
  "cssls",
  "html",
  "tailwindcss",
  "eslint",
  "intelephense",
  "gopls",
  "marksman",
  "emmet_language_server",
}
