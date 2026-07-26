local map = vim.keymap.set
local opts = { silent = true }

-- Basics
map("n", "<leader>h", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
-- Built-in commenting (Neovim 0.10+): gcc line, gc{motion} / visual gc
map("n", "<leader>/", "gcc", { desc = "Toggle comment line", remap = true })
map("x", "<leader>/", "gc", { desc = "Toggle comment selection", remap = true })

-- Movement
map("n", "J", "mzJ`z", opts)
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)
map("n", "n", "nzzzv", opts)
map("n", "N", "Nzzzv", opts)

-- Quick editing shortcuts
map("n", "<leader>rl", "<cmd>lsp restart<cr>", { desc = "Restart LSP" })

-- Tree
map("n", "<leader>e", "<cmd>Neotree float<cr>", { desc = "Focus File Tree" })
map("n", "<leader>tb", "<cmd>Neotree buffers<cr>", { desc = "Show open buffers" })

-- Telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Telescope find files" })
map("n", "<leader>fl", "<cmd>Telescope live_grep<cr>", { desc = "Telescope live grep" })
map("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", { desc = "Telescope diagnostics" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Telescope buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Telescope help tags" })

-- LuxTerminal
map("n", "<leader>tt", "<cmd>LuxtermToggle<cr>", { desc = "Luxterm toggle" })

-- Theme
map("n", "<leader>tT", "<cmd>ToggleTheme<CR>", { desc = "Toggle theme" })
map("n", "<leader>ts", "<cmd>SyncTheme<CR>", { desc = "Sync theme with system" })

-- Buffers
map("n", "<leader>bn", "<cmd>BufferNext<CR>", { desc = "Go to next buffer." })
map("n", "<leader>bp", "<cmd>BufferPrevious<CR>", { desc = "Go to previous buffer." })

-- Insert-mode escape
map("i", "jk", "<ESC>")

-- LSP: keep a few leader maps for muscle memory; prefer built-ins when possible:
--   gra code action, grn rename, grr refs, gri impl, grt type def
--   ]d / [d diagnostics, K hover (set on LspAttach by defaults when supported)
map("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "<leader>ac", vim.lsp.buf.code_action, { desc = "Code actions" })
map("n", "<leader>er", function()
  vim.diagnostic.jump { count = 1, float = true }
end, { desc = "Next diagnostic" })

-- Format file (project formatters via conform; LSP only if none available)
map("n", "<leader>fm", function()
  require("conform").format { lsp_format = "fallback" }
end, { desc = "Format file" })

-- Git
map("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "LazyGit" })
