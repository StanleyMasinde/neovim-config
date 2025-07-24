require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")


-- My mapping for LSP functions.
-- They won't make sense for most so if you are basing your config on mine,
-- Feel free to modify the config below.
-- E.g g-d goes to variable definition,
-- <leader>a-c will show code actions
-- <leader>e-r will jump to the next error and show it in details
vim.api.nvim_set_keymap("n", "<leader>gd", "<cmd>lua vim.lsp.buf.definition()<CR>",
  { noremap = true, silent = true, desc = "Go to definition" })
vim.api.nvim_set_keymap("n", "<leader>ac", "<cmd>lua vim.lsp.buf.code_action()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>er", "<cmd>lua vim.diagnostic.goto_next()<CR>", { noremap = true, silent = true })

-- ESLint specific mappings
vim.api.nvim_set_keymap("n", "<leader>ef", "<cmd>EslintFixAll<CR>",
  { noremap = true, silent = true, desc = "ESLint fix all" })
vim.api.nvim_set_keymap("n", "<leader>el", "<cmd>lua require('lint').try_lint()<CR>",
  { noremap = true, silent = true, desc = "Run ESLint" })

-- Format file
vim.api.nvim_set_keymap("n", "<leader>fm", "<cmd>lua require('conform').format({ lsp_fallback = true })<CR>",
  { noremap = true, silent = true, desc = "Format file" })

-- DAP (Debugger) mappings
vim.api.nvim_set_keymap("n", "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<CR>",
  { noremap = true, silent = true, desc = "Toggle Breakpoint" })
vim.api.nvim_set_keymap("n", "<leader>dc", "<cmd>lua require('dap').continue()<CR>",
  { noremap = true, silent = true, desc = "Continue" })
vim.api.nvim_set_keymap("n", "<leader>dso", "<cmd>lua require('dap').step_over()<CR>",
  { noremap = true, silent = true, desc = "Step Over" })
vim.api.nvim_set_keymap("n", "<leader>dsi", "<cmd>lua require('dap').step_into()<CR>",
  { noremap = true, silent = true, desc = "Step Into" })
vim.api.nvim_set_keymap("n", "<leader>dsO", "<cmd>lua require('dap').step_out()<CR>",
  { noremap = true, silent = true, desc = "Step Out" })
vim.api.nvim_set_keymap("n", "<leader>dr", "<cmd>lua require('dap.repl').open()<CR>",
  { noremap = true, silent = true, desc = "Open REPL" })
vim.api.nvim_set_keymap("n", "<leader>dt", "<cmd>lua require('dapui').toggle()<CR>",
  { noremap = true, silent = true, desc = "Toggle DAP UI" })
vim.api.nvim_set_keymap("n", "<leader>dx", "<cmd>lua require('dap').terminate()<CR>",
  { noremap = true, silent = true, desc = "Terminate" })
vim.api.nvim_set_keymap("n", "<leader>dR", "<cmd>lua require('dap').restart()<CR>",
  { noremap = true, silent = true, desc = "Restart" })

-- Theme sync mapping
vim.api.nvim_set_keymap("n", "<leader>ts", "<cmd>SyncTheme<CR>",
  { noremap = true, silent = true, desc = "Sync theme with system" })

-- Git mappings
vim.api.nvim_set_keymap("n", "<leader>gg", "<cmd>LazyGit<CR>", { noremap = true, silent = true, desc = "LazyGit" })
vim.api.nvim_set_keymap("n", "<leader>gs", "<cmd>Git<CR>", { noremap = true, silent = true, desc = "Git status" })
vim.api.nvim_set_keymap("n", "<leader>gb", "<cmd>Git blame<CR>", { noremap = true, silent = true, desc = "Git blame" })
vim.api.nvim_set_keymap("n", "<leader>gF", "<cmd>Gdiffsplit<CR>",
  { noremap = true, silent = true, desc = "Git diff split" })

-- Project and session management
vim.api.nvim_set_keymap("n", "<leader>fp", "<cmd>Telescope projects<CR>",
  { noremap = true, silent = true, desc = "Find projects" })
vim.api.nvim_set_keymap("n", "<leader>qs", "<cmd>lua require('persistence').load()<CR>",
  { noremap = true, silent = true, desc = "Restore session" })
vim.api.nvim_set_keymap("n", "<leader>ql", "<cmd>lua require('persistence').load({ last = true })<CR>",
  { noremap = true, silent = true, desc = "Restore last session" })
vim.api.nvim_set_keymap("n", "<leader>qd", "<cmd>lua require('persistence').stop()<CR>",
  { noremap = true, silent = true, desc = "Stop session recording" })

-- Harpoon mappings
vim.api.nvim_set_keymap("n", "<leader>ha", "<cmd>lua require('harpoon'):list():add()<CR>",
  { noremap = true, silent = true, desc = "Harpoon add file" })
vim.api.nvim_set_keymap("n", "<leader>hm",
  "<cmd>lua require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())<CR>",
  { noremap = true, silent = true, desc = "Harpoon menu" })
vim.api.nvim_set_keymap("n", "<leader>1", "<cmd>lua require('harpoon'):list():select(1)<CR>",
  { noremap = true, silent = true, desc = "Harpoon file 1" })
vim.api.nvim_set_keymap("n", "<leader>2", "<cmd>lua require('harpoon'):list():select(2)<CR>",
  { noremap = true, silent = true, desc = "Harpoon file 2" })
vim.api.nvim_set_keymap("n", "<leader>3", "<cmd>lua require('harpoon'):list():select(3)<CR>",
  { noremap = true, silent = true, desc = "Harpoon file 3" })
vim.api.nvim_set_keymap("n", "<leader>4", "<cmd>lua require('harpoon'):list():select(4)<CR>",
  { noremap = true, silent = true, desc = "Harpoon file 4" })

-- Trouble diagnostics
vim.api.nvim_set_keymap("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>",
  { noremap = true, silent = true, desc = "Diagnostics (Trouble)" })
vim.api.nvim_set_keymap("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
  { noremap = true, silent = true, desc = "Buffer Diagnostics (Trouble)" })
vim.api.nvim_set_keymap("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<CR>",
  { noremap = true, silent = true, desc = "Symbols (Trouble)" })
vim.api.nvim_set_keymap("n", "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<CR>",
  { noremap = true, silent = true, desc = "LSP Definitions / references / ... (Trouble)" })

-- Enhanced code actions
vim.api.nvim_set_keymap("n", "<leader>ca", "<cmd>CodeActionMenu<CR>",
  { noremap = true, silent = true, desc = "Code Action Menu" })

-- Refactoring
vim.api.nvim_set_keymap("v", "<leader>re", "<cmd>lua require('refactoring').refactor('Extract Function')<CR>",
  { noremap = true, silent = true, desc = "Extract Function" })
vim.api.nvim_set_keymap("v", "<leader>rf", "<cmd>lua require('refactoring').refactor('Extract Function To File')<CR>",
  { noremap = true, silent = true, desc = "Extract Function To File" })
vim.api.nvim_set_keymap("v", "<leader>rv", "<cmd>lua require('refactoring').refactor('Extract Variable')<CR>",
  { noremap = true, silent = true, desc = "Extract Variable" })
vim.api.nvim_set_keymap("v", "<leader>ri", "<cmd>lua require('refactoring').refactor('Inline Variable')<CR>",
  { noremap = true, silent = true, desc = "Inline Variable" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
