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

-- Config files that mean "this project uses Prettier".
local prettier_config_files = {
  ".prettierrc",
  ".prettierrc.json",
  ".prettierrc.yml",
  ".prettierrc.yaml",
  ".prettierrc.json5",
  ".prettierrc.js",
  ".prettierrc.cjs",
  ".prettierrc.mjs",
  ".prettierrc.ts",
  ".prettierrc.cts",
  ".prettierrc.mts",
  ".prettierrc.toml",
  "prettier.config.js",
  "prettier.config.cjs",
  "prettier.config.mjs",
  "prettier.config.ts",
  "prettier.config.cts",
  "prettier.config.mts",
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

---@param bufnr integer
---@param key string
---@return boolean
local function package_json_has_key(bufnr, key)
  local data = read_package_json(bufnr)
  return data ~= nil and data[key] ~= nil
end

---True if package.json lists the package in any dependency field.
---@param bufnr integer
---@param name string
---@return boolean
local function package_has_dependency(bufnr, name)
  local data = read_package_json(bufnr)
  if not data then
    return false
  end
  for _, field in ipairs { "dependencies", "devDependencies", "optionalDependencies", "peerDependencies" } do
    local deps = data[field]
    if type(deps) == "table" and deps[name] ~= nil then
      return true
    end
  end
  return false
end

---@param bufnr integer
---@return boolean
local function project_has_eslint(bufnr)
  -- Config only: many repos depend on eslint for lint CI without using it to format.
  return has_file_upward(bufnr, eslint_config_files) or package_json_has_key(bufnr, "eslintConfig")
end

---@param bufnr integer
---@return boolean
local function project_has_prettier(bufnr)
  return has_file_upward(bufnr, prettier_config_files)
    or package_json_has_key(bufnr, "prettier")
    or package_has_dependency(bufnr, "prettier")
end

---@param bufnr integer
---@return boolean
local function project_has_oxlint(bufnr)
  return has_file_upward(bufnr, oxlint_config_files) or package_has_dependency(bufnr, "oxlint")
end

---@param bufnr integer
---@return boolean
local function project_has_oxfmt(bufnr)
  return has_file_upward(bufnr, oxfmt_config_files) or package_has_dependency(bufnr, "oxfmt")
end

---Follow the project for JS-family (and CSS/HTML/JSON) formatting.
---
---Lint/fix (prefer Oxc over ESLint when both exist):
---  oxlint config/dep → oxlint --fix
---  else eslint       → eslint --fix
---
---Pure format (prefer Oxc over Prettier when both exist):
---  oxfmt config/dep  → oxfmt
---  else prettier cfg → prettier
---  else if nothing   → prettier (default)
---@param bufnr integer
---@return string[]
local function project_js_formatters(bufnr)
  local formatters = {}

  -- Auto-fix linters first.
  if project_has_oxlint(bufnr) then
    table.insert(formatters, "oxlint")
  elseif project_has_eslint(bufnr) then
    table.insert(formatters, "eslint_fix")
  end

  -- Then pretty-printers.
  if project_has_oxfmt(bufnr) then
    table.insert(formatters, "oxfmt")
  elseif project_has_prettier(bufnr) then
    table.insert(formatters, "prettier")
  elseif #formatters == 0 then
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
