require("nvchad.configs.lspconfig").defaults()

-- Vue and TypeScript configuration using Neovim 0.11+ LSP API
local vue_language_server_path = vim.fn.stdpath('data') ..
"/mason/packages/vue-language-server/node_modules/@vue/language-server"

-- Check if Vue language server exists
local vue_server_exists = vim.fn.isdirectory(vue_language_server_path) == 1

if not vue_server_exists then
  vim.notify("Vue Language Server not found. Install with: :MasonInstall vue-language-server", vim.log.levels.WARN)
end

-- TypeScript with Vue plugin support
local vue_plugin = {
  name = '@vue/typescript-plugin',
  location = vue_language_server_path,
  languages = { 'vue' },
}

vim.lsp.config('vtsls', {
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = vue_server_exists and { vue_plugin } or {},
      },
    },
  },
  filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
})

-- Vue Language Server (vue_ls) for enhanced Vue support
if vue_server_exists then
  vim.lsp.config('vue_ls', {
    on_new_config = function(new_config, new_root_dir)
      new_config.init_options.typescript = {
        tsdk = vim.fn.stdpath('data') .. '/mason/packages/typescript-language-server/node_modules/typescript/lib'
      }
    end,
    filetypes = { 'vue' },
  })
end

-- HTML and CSS Language Servers
vim.lsp.config('html', {
  filetypes = { 'html' },
})

vim.lsp.config('cssls', {
  filetypes = { 'css', 'scss', 'less' },
})

-- ESLint Language Server
vim.lsp.config('eslint', {
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue' },
})

-- Enable all configured language servers (rust_analyzer handled by rustaceanvim)
local servers = { "html", "cssls", "vtsls", "eslint" }
if vue_server_exists then
  table.insert(servers, "vue_ls")
end

vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers
