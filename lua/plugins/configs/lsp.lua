-- Vue language server plugin path (Mason v2 layout).
local mason_packages = vim.fn.expand "$MASON/packages"
local vue_language_server_path = mason_packages .. "/vue-language-server" .. "/node_modules/@vue/language-server"

-- vue_ls needs a TypeScript build that still exposes `ts.server` (TS 5/6).
-- Mason's vue-language-server currently vendors TypeScript 7.x where `ts.server`
-- is undefined, which crashes the server with:
--   TypeError: Cannot read properties of undefined (reading 'protocol')
-- Prefer the project workspace tsdk, then fall back to Mason's ts_ls TypeScript.
local mason_tsdk = mason_packages .. "/typescript-language-server/node_modules/typescript/lib"

---@param root_dir string|nil
---@return string
local function resolve_tsdk(root_dir)
  if root_dir then
    local project_tsdk = vim.fs.joinpath(root_dir, "node_modules", "typescript", "lib")
    if vim.uv.fs_stat(project_tsdk) then
      return project_tsdk
    end
  end
  return mason_tsdk
end

local tsserver_filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" }
local vue_plugin = {
  name = "@vue/typescript-plugin",
  location = vue_language_server_path,
  languages = { "vue" },
  configNamespace = "typescript",
}

-- Hybrid mode: ts_ls + @vue/typescript-plugin handles script/TS in .vue files;
-- vue_ls handles template/style and talks to ts_ls via tsserver/request.
vim.lsp.config("ts_ls", {
  init_options = {
    plugins = {
      vue_plugin,
    },
  },
  filetypes = tsserver_filetypes,
})

vim.lsp.config("vue_ls", {
  cmd = function(dispatchers, config)
    local tsdk = resolve_tsdk(config and config.root_dir or nil)
    return vim.lsp.rpc.start({
      "vue-language-server",
      "--stdio",
      "--tsdk=" .. tsdk,
    }, dispatchers)
  end,
})

vim.lsp.config("harper_ls", {
  cmd = { "harper-ls", "--stdio" },
  filetypes = {
    -- Prose / Markup
    "markdown",
    "text",
    "gitcommit",
    "asciidoc",
    "typst",
    "org",
    "mail",
    "tex",
    "latex",
    "html",

    -- Programming Languages (checks comments & strings)
    "rust",
    "c",
    "cpp",
    "csharp",
    "go",
    "python",
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "java",
    "kotlin",
    "swift",
    "lua",
    "php",
    "ruby",
    "elixir",
    "zig",
    "nix",
    "sh",
    "bash",
    "powershell",
    "toml",
  },
  root_markers = { ".git" },
  settings = {
    ["harper-ls"] = {
      dialect = "British",
      userDictPath = "~/.config/harper-ls/user_dict.txt",
      linters = {
        spell_check = true,
        spelled_numbers = false,
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
  "harper_ls",
}
