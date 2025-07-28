local dap = require("dap")

-- Rust configuration
dap.adapters.codelldb = {
  type = 'server',
  port = "${port}",
  executable = {
    command = vim.fn.stdpath("data") .. '/mason/bin/codelldb',
    args = { "--port", "${port}" },
  }
}

dap.configurations.rust = {
  {
    name = "Launch file",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
  },
  {
    name = "Launch file (with args)",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
    end,
    args = function()
      local args_string = vim.fn.input('Arguments: ')
      return vim.split(args_string, " ")
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
  },
  {
    name = "Launch current package",
    type = "codelldb",
    request = "launch",
    program = function()
      -- Get the current package name from Cargo.toml
      local handle = io.popen("cargo metadata --format-version 1 --no-deps | jq -r '.packages[0].name'")
      local package_name = handle:read("*a"):gsub("%s+", "")
      handle:close()
      return vim.fn.getcwd() .. '/target/debug/' .. package_name
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    preLaunchTask = "cargo build",
  },
}

-- JavaScript/TypeScript configuration
dap.adapters.node2 = {
  type = 'executable',
  command = 'node',
  args = { vim.fn.stdpath("data") .. '/mason/packages/node-debug2-adapter/out/src/nodeDebug.js' },
}

dap.configurations.javascript = {
  {
    name = 'Launch',
    type = 'node2',
    request = 'launch',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal',
  },
  {
    name = 'Attach to process',
    type = 'node2',
    request = 'attach',
    processId = require 'dap.utils'.pick_process,
  },
}

dap.configurations.typescript = dap.configurations.javascript

-- PHP configuration
dap.adapters.php = {
  type = 'executable',
  command = 'node',
  args = { vim.fn.stdpath("data") .. '/mason/packages/php-debug-adapter/extension/out/phpDebug.js' }
}

dap.configurations.php = {
  {
    name = 'Listen for Xdebug',
    type = 'php',
    request = 'launch',
    port = 9003,
    log = false,
    pathMappings = {
      ["/app"] = "${workspaceFolder}",
    },
  },
  {
    name = 'Launch currently open script',
    type = 'php',
    request = 'launch',
    program = '${file}',
    cwd = '${fileDirname}',
    port = 0,
    runtimeArgs = {
      '-dxdebug.start_with_request=yes'
    },
    env = {
      XDEBUG_MODE = 'debug,develop',
      XDEBUG_CONFIG = 'client_port=${port}'
    }
  },
  {
    name = 'Launch Built-in web server',
    type = 'php',
    request = 'launch',
    runtimeArgs = {
      '-dxdebug.mode=debug',
      '-dxdebug.start_with_request=yes',
      '-S',
      'localhost:8000'
    },
    program = '',
    cwd = '${workspaceFolder}',
    port = 9003,
    serverReadyAction = {
      pattern = 'Development Server \\(http://localhost:([0-9]+)\\) started',
      uriFormat = 'http://localhost:%s',
      action = 'openExternally'
    }
  }
}
