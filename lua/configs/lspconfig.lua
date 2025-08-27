require("nvchad.configs.lspconfig").defaults()

-- Vue and TypeScript configuration using a more compatible approach
local function check_vue_server()
  local home = os.getenv("HOME")
  if not home then return false end

  local vue_path = home .. "/.local/share/nvim/mason/packages/vue-language-server"
  local handle = io.popen("ls -l " .. vue_path .. " 2>/dev/null")
  local result = ""
  if handle then
    result = handle:read("*a") or ""
    handle:close()
  end
  return result ~= ""
end

-- Define the path to the Vue language server
local vue_language_server_path = os.getenv("HOME") ..
    "/.local/share/nvim/mason/packages/vue-language-server/node_modules/@vue/language-server"

-- Check if Vue language server exists
local vue_server_exists = check_vue_server()

-- Function to check if a command exists on the system
local function command_exists(cmd)
  local handle = io.popen("which " .. cmd)
  local result = handle and handle:read("*a") or ""
  if handle then handle:close() end
  return result ~= ""
end

-- TypeScript with Vue plugin support
local vue_plugin = {
  name = '@vue/typescript-plugin',
  location = vue_language_server_path,
  languages = { 'vue' },
}

-- Configure TypeScript server if available
vim.lsp.config('vtsls', {
  settings = {
    vtsls = {
      tsserver = {
        -- Only use Vue plugin if Vue language server is installed
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
      -- Try to use TypeScript from the project first, then fall back to mason
      local project_ts_path = new_root_dir .. "/node_modules/typescript/lib"
      local mason_ts_path = vim.fn.stdpath('data') ..
          '/mason/packages/typescript-language-server/node_modules/typescript/lib'

      local ts_path = vim.fn.isdirectory(project_ts_path) == 1 and project_ts_path or mason_ts_path

      new_config.init_options.typescript = {
        tsdk = ts_path
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

-- HTML and CSS servers already configured above

-- ESLint Language Server - check if eslint is installed in project
local function has_eslint_config(root_dir)
  local eslint_files = {
    '.eslintrc.js',
    '.eslintrc.cjs',
    '.eslintrc.yaml',
    '.eslintrc.yml',
    '.eslintrc.json',
    '.eslintrc',
    'eslint.config.js',
    'eslint.config.mjs'
  }

  for _, file in ipairs(eslint_files) do
    local eslint_path = root_dir .. '/' .. file
    local f = io.open(eslint_path, "r")
    if f then
      f:close()
      return true
    end
  end

  -- Check if eslint is in package.json
  local package_json = root_dir .. '/package.json'
  local f = io.open(package_json, "r")
  if f then
    local content = f:read("*all")
    f:close()
    if content:find([["eslint"]]) or content:find([["eslint-plugin"]]) then
      return true
    end
  end

  return false
end

-- Configure ESLint LSP only if ESLint config exists in the project
vim.lsp.config('eslint', {
  filetypes = { 'javascript', 'typescript', 'vue' },
  on_new_config = function(new_config, new_root_dir)
    if not has_eslint_config(new_root_dir) then
      return false
    end
  end,
})

-- PHP Language Server (Intelephense)
vim.lsp.config('intelephense', {
  filetypes = { 'php' },
  settings = {
    intelephense = {
      files = {
        maxSize = 1000000,
      },
      format = {
        enable = true,
      },
      completion = {
        insertUseDeclaration = true,
        fullyQualifyGlobalConstantsAndFunctions = false,
        triggerParameterHints = true,
        maxItems = 100,
      },
      diagnostics = {
        enable = true,
      },
    },
  },
})


-- Detect project type and needed servers
local function detect_project_servers()
  local servers = {}
  local cwd = io.popen("pwd"):read("*l") -- Get current working directory in a more compatible way

  -- Function to check if a file exists in the current directory or parent directories
  local function find_file_up(file_name, max_depth)
    local path = cwd
    local depth = 0
    max_depth = max_depth or 5

    while depth < max_depth do
      local file_path = path .. '/' .. file_name
      local f = io.open(file_path, "r")
      if f then
        f:close()
        return true
      end

      -- Try parent directory
      path = path:match("(.*)/[^/]+$")
      if not path then
        break
      end

      depth = depth + 1
    end

    return false
  end

  -- Function to check if files with a pattern exist
  local function has_files_with_ext(ext)
    local handle = io.popen("find " .. cwd .. " -type f -name '*." .. ext .. "' | head -1")
    local result = ""
    if handle then
      result = handle:read("*a") or ""
      handle:close()
    end
    return result ~= ""
  end

  -- Function to check package.json for dependency
  local function check_package_json_for(pkg_name)
    local pkg_json_path = cwd .. "/package.json"
    local f = io.open(pkg_json_path, "r")
    if not f then return false end

    local content = f:read("*all")
    f:close()
    return content:find("[\"']" .. pkg_name .. "[\"']")
  end

  -- Always include HTML and CSS servers
  table.insert(servers, "html")
  table.insert(servers, "cssls")

  -- Tailwind CSS server removed

  -- Add TypeScript server if TS files exist or it's in dependencies
  if check_package_json_for("typescript") or
      has_files_with_ext("ts") or
      has_files_with_ext("tsx") then
    table.insert(servers, "vtsls")
  end

  -- Add ESLint server if it might be used in the project
  if check_package_json_for("eslint") or
      find_file_up(".eslintrc.js") or
      find_file_up(".eslintrc.json") or
      find_file_up(".eslintrc") then
    table.insert(servers, "eslint")
  end

  -- Add Vue LS if Vue files exist or Vue is in dependencies
  if vue_server_exists and
      (check_package_json_for("vue") or has_files_with_ext("vue")) then
    table.insert(servers, "vue_ls")
  end

  -- Check for PHP files
  if has_files_with_ext("php") then
    table.insert(servers, "intelephense")
  end

  return servers
end

-- Enable servers based on what's detected in the project
-- Note: rust_analyzer is handled by rustaceanvim
local servers = detect_project_servers()
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers
