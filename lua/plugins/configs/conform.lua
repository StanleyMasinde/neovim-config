local util = require "conform.util"

-- Config files that mean "this project uses ESLint" (legacy + flat).
local eslint_config_files = {
  ".eslintrc",
  ".eslintrc.js",
  ".eslintrc.cjs",
  ".eslintrc.yaml",
  ".eslintrc.yml",
  ".eslintrc.json",
  "eslint.config.js",
  "eslint.config.mjs",
  "eslint.config.cjs",
  "eslint.config.ts",
  "eslint.config.mts",
  "eslint.config.cts",
}

-- https://oxc.rs/docs/guide/usage/linter/config.html
local oxlint_config_files = {
  ".oxlintrc.json",
  ".oxlintrc.jsonc",
  "oxlint.config.ts",
  "oxlint.config.mts",
}

-- https://oxc.rs/docs/guide/usage/formatter/config.html
local oxfmt_config_files = {
  ".oxfmtrc.json",
  ".oxfmtrc.jsonc",
  "oxfmt.config.ts",
  "oxfmt.config.mts",
}

---@param bufnr integer
---@return string
local function buf_search_path(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == "" then
    return vim.fn.getcwd()
  end
  return vim.fs.dirname(name)
end

---@param bufnr integer
---@param names string[]
---@return boolean
local function has_file_upward(bufnr, names)
  local found = vim.fs.find(names, {
    path = buf_search_path(bufnr),
    upward = true,
    type = "file",
    limit = 1,
  })
  return found[1] ~= nil
end

---@param bufnr integer
---@return table|nil
local function read_package_json(bufnr)
  local pkg = vim.fs.find("package.json", {
    path = buf_search_path(bufnr),
    upward = true,
    type = "file",
    limit = 1,
  })[1]
  if not pkg then
    return nil
  end

  local ok, data = pcall(function()
    return vim.json.decode(table.concat(vim.fn.readfile(pkg), "\n"))
  end)
  if ok and type(data) == "table" then
    return data
  end
  return nil
end

---True if package.json lists the package in any dependency field.
---@param data table
---@param name string
---@return boolean
local function package_has_dependency(data, name)
  for _, field in ipairs { "dependencies", "devDependencies", "optionalDependencies", "peerDependencies" } do
    local deps = data[field]
    if type(deps) == "table" and deps[name] ~= nil then
      return true
    end
  end
  return false
end

local lint_filetypes = {
  javascript = true,
  javascriptreact = true,
  typescript = true,
  typescriptreact = true,
  vue = true,
}

---Run project lint fixes for JS-family files, then always select a formatter.
---@param bufnr integer
---@return string[]
local function project_js_formatters(bufnr)
  local data = read_package_json(bufnr) or {}
  local formatters = {}

  if lint_filetypes[vim.bo[bufnr].filetype] then
    if has_file_upward(bufnr, oxlint_config_files) or package_has_dependency(data, "oxlint") then
      table.insert(formatters, "oxlint")
    elseif has_file_upward(bufnr, eslint_config_files) or data.eslintConfig ~= nil then
      table.insert(formatters, "eslint_fix")
    end
  end

  if has_file_upward(bufnr, oxfmt_config_files) or package_has_dependency(data, "oxfmt") then
    table.insert(formatters, "oxfmt")
  else
    table.insert(formatters, "prettier")
  end

  return formatters
end

local options = {
  formatters = {
    -- Prefer project-local `eslint` (not eslint_d). Works with flat config + stylistic.
    eslint_fix = {
      command = util.from_node_modules "eslint",
      args = { "--fix", "$FILENAME" },
      stdin = false,
      cwd = util.root_file {
        "package.json",
        "eslint.config.js",
        "eslint.config.mjs",
        "eslint.config.cjs",
        "eslint.config.ts",
        "eslint.config.mts",
        "eslint.config.cts",
        ".eslintrc",
        ".eslintrc.js",
        ".eslintrc.cjs",
        ".eslintrc.json",
        ".eslintrc.yml",
        ".eslintrc.yaml",
      },
      -- Remaining unfixed issues still exit 1 after successful fixes.
      exit_codes = { 0, 1 },
    },

    -- Ensure cwd resolves for projects that only declare the package (no config file yet).
    oxlint = {
      cwd = util.root_file {
        "package.json",
        ".oxlintrc.json",
        ".oxlintrc.jsonc",
        "oxlint.config.ts",
        "oxlint.config.mts",
      },
    },
    oxfmt = {
      cwd = util.root_file {
        "package.json",
        ".oxfmtrc.json",
        ".oxfmtrc.jsonc",
        "oxfmt.config.ts",
        "oxfmt.config.mts",
      },
    },
  },

  formatters_by_ft = {
    lua = { "stylua" },
    php = { "php_cs_fixer" },

    -- Per-buffer project detection (not a one-shot getcwd() at startup).
    javascript = project_js_formatters,
    javascriptreact = project_js_formatters,
    typescript = project_js_formatters,
    typescriptreact = project_js_formatters,
    vue = project_js_formatters,
    css = project_js_formatters,
    scss = project_js_formatters,
    html = project_js_formatters,
    json = project_js_formatters,
    jsonc = project_js_formatters,
  },
}

return options
