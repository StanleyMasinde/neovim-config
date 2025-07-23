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

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
