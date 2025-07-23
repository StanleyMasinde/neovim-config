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
vim.api.nvim_set_keymap("n", "<leader>gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>ac", "<cmd>lua vim.lsp.buf.code_action()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>er", "<cmd>lua vim.diagnostic.goto_next()<CR>", { noremap = true, silent = true })

-- ESLint specific mappings
vim.api.nvim_set_keymap("n", "<leader>ef", "<cmd>EslintFixAll<CR>", { noremap = true, silent = true, desc = "ESLint fix all" })
vim.api.nvim_set_keymap("n", "<leader>el", "<cmd>lua require('lint').try_lint()<CR>", { noremap = true, silent = true, desc = "Run ESLint" })

-- Format file
vim.api.nvim_set_keymap("n", "<leader>fm", "<cmd>lua require('conform').format({ lsp_fallback = true })<CR>", { noremap = true, silent = true, desc = "Format file" })

-- DAP (Debugger) mappings
vim.api.nvim_set_keymap("n", "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<CR>", { noremap = true, silent = true, desc = "Toggle Breakpoint" })
vim.api.nvim_set_keymap("n", "<leader>dc", "<cmd>lua require('dap').continue()<CR>", { noremap = true, silent = true, desc = "Continue" })
vim.api.nvim_set_keymap("n", "<leader>dso", "<cmd>lua require('dap').step_over()<CR>", { noremap = true, silent = true, desc = "Step Over" })
vim.api.nvim_set_keymap("n", "<leader>dsi", "<cmd>lua require('dap').step_into()<CR>", { noremap = true, silent = true, desc = "Step Into" })
vim.api.nvim_set_keymap("n", "<leader>dsO", "<cmd>lua require('dap').step_out()<CR>", { noremap = true, silent = true, desc = "Step Out" })
vim.api.nvim_set_keymap("n", "<leader>dr", "<cmd>lua require('dap.repl').open()<CR>", { noremap = true, silent = true, desc = "Open REPL" })
vim.api.nvim_set_keymap("n", "<leader>dt", "<cmd>lua require('dapui').toggle()<CR>", { noremap = true, silent = true, desc = "Toggle DAP UI" })
vim.api.nvim_set_keymap("n", "<leader>dx", "<cmd>lua require('dap').terminate()<CR>", { noremap = true, silent = true, desc = "Terminate" })
vim.api.nvim_set_keymap("n", "<leader>dR", "<cmd>lua require('dap').restart()<CR>", { noremap = true, silent = true, desc = "Restart" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
