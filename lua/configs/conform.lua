-- Detect if certain tools are available in the project
local function has_file(file)
  local f = io.open(file, "r")
  if f then
    f:close()
    return true
  end
  return false
end

local function get_cwd()
  -- Get current working directory in a shell-independent way
  local handle = io.popen("pwd")
  local result = ""
  if handle then
    result = handle:read("*a"):gsub("\n$", "")
    handle:close()
  end
  return result
end

local function has_any_file(files, root)
  root = root or get_cwd()
  for _, file in ipairs(files) do
    if has_file(root .. '/' .. file) then
      return true
    end
  end
  return false
end

-- Determine formatters based on project configuration
local function get_formatters_for_project()
  local root = get_cwd()

  -- Check for ESLint config
  local eslint_configs = {
    '.eslintrc.js', '.eslintrc.cjs', '.eslintrc.yaml',
    '.eslintrc.yml', '.eslintrc.json', '.eslintrc',
    'eslint.config.js', 'eslint.config.mjs'
  }

  -- Check for Prettier config
  local prettier_configs = {
    '.prettierrc', '.prettierrc.js', '.prettierrc.cjs',
    '.prettierrc.json', '.prettierrc.yaml', '.prettierrc.yml',
    'prettier.config.js', 'prettier.config.cjs', '.prettier.config.mjs'
  }

  local has_eslint = has_any_file(eslint_configs, root)
  local has_prettier = has_any_file(prettier_configs, root)

  -- Default formatters
  local js_formatters = {}

  -- Prefer ESLint if available
  if has_eslint then
    table.insert(js_formatters, "eslint_d")
  end

  -- Use Prettier as fallback or additional formatter
  if has_prettier then
    table.insert(js_formatters, "prettier")
  elseif #js_formatters == 0 then
    -- If no formatters found, default to prettier
    table.insert(js_formatters, "prettier")
  end

  return {
    lua = { "stylua" },
    javascript = js_formatters,
    javascriptreact = js_formatters,
    typescript = js_formatters,
    typescriptreact = js_formatters,
    vue = js_formatters,
    php = { "php_cs_fixer" },
    css = { "prettier" },
    html = { "prettier" },
  }
end

local options = {
  formatters_by_ft = get_formatters_for_project(),

  -- Uncomment to enable format on save
  -- format_on_save = {
  --   timeout_ms = 500,
  --   lsp_fallback = true,
  -- },
}

return options
