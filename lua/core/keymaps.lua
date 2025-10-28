local map = vim.keymap.set
local opts = { silent = true, noremap = true }

-- Basics
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit window" })
map("n", "<leader>h", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
map("n", "<leader>e", "<cmd>Explore<cr>", { desc = "Open file explorer" })

-- Movement
map("n", "J", "mzJ`z", opts)
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)
map("n", "n", "nzzzv", opts)
map("n", "N", "Nzzzv", opts)

-- Quick editing shortcuts
map("n", "<leader>sv", "<cmd>source $MYVIMRC<cr>", { desc = "Reload config" })
map("n", "<leader>rl", "<cmd>LspRestart<cr>", { desc = "Restart LSP" })

-- Tree
map("n", "<leader>e", "<cmd>Neotree float<cr>", { desc = "Focus File Tree" })
map("n", "<leader>tb", "<cmd>Neotree buffers<cr>", { desc = "Show open buffers" })

-- Telescope
map("n", "<leader>fl", "<cmd>Telescope live_grep<cr>", { desc = "Telescope live grep" })
map("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", { desc = "Telescope diagnostics" })

-- LuxTerminal
map("n", "<leader>tt", "<cmd>LuxtermToggle<cr>", { desc = "Luxterm toggle" })

-- Theme
map("n", "<leader>tT", "<cmd>ToggleTheme<CR>", { desc = "Toggle theme" })

-- Buffers
map("n", "<leader>bn", "<cmd>BufferNext<CR>", { desc = "Go to next buffer." })
map("n", "<leader>bp", "<cmd>BufferPrevious<CR>", { desc = "Go to previous buffer buffer." })

-- Legacy mappings.
-- I will update them to match the new ethos
map("i", "jk", "<ESC>")

-- My mapping for LSP functions.
-- Leader key is <space>, so all <leader> mappings start with <space>
-- E.g <space>gd goes to variable definition,
-- <space>ac will show code actions
-- <space>er will jump to the next error and show it in details
-- PHP specific: <space>pl runs PHPStan, <space>pf formats PHP files

-- LSP mappings
map("n", "<leader>gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { desc = "Go to definition" })
map("n", "<leader>ac", "<cmd>lua vim.lsp.buf.code_action()<CR>", { desc = "Code actions" })
map("n", "<leader>er", "<cmd>lua vim.diagnostic.goto_next()<CR>", { desc = "Next diagnostic" })

-- ESLint specific mappings
map("n", "<leader>ef", "<cmd>EslintFixAll<CR>", { desc = "ESLint fix all" })
map("n", "<leader>el", "<cmd>lua require('lint').try_lint()<CR>", { desc = "Run ESLint" })

-- PHP specific mappings
map("n", "<leader>pl", "<cmd>lua require('lint').try_lint()<CR>", { desc = "Run PHPStan" })
map("n", "<leader>pf", "<cmd>lua require('conform').format({ lsp_fallback = true })<CR>", { desc = "Format PHP file" })

-- Format file
map("n", "<leader>fm", "<cmd>lua require('conform').format({ lsp_fallback = true })<CR>", { desc = "Format file" })

-- DAP (Debugger) mappings
map("n", "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<CR>", { desc = "Toggle Breakpoint" })
map("n", "<leader>dc", "<cmd>lua require('dap').continue()<CR>", { desc = "Continue" })
map("n", "<leader>dso", "<cmd>lua require('dap').step_over()<CR>", { desc = "Step Over" })
map("n", "<leader>dsi", "<cmd>lua require('dap').step_into()<CR>", { desc = "Step Into" })
map("n", "<leader>dsO", "<cmd>lua require('dap').step_out()<CR>", { desc = "Step Out" })
map("n", "<leader>dr", "<cmd>lua require('dap.repl').open()<CR>", { desc = "Open REPL" })
map("n", "<leader>dt", "<cmd>lua require('dapui').toggle()<CR>", { desc = "Toggle DAP UI" })
map("n", "<leader>dx", "<cmd>lua require('dap').terminate()<CR>", { desc = "Terminate" })
map("n", "<leader>dR", "<cmd>lua require('dap').restart()<CR>", { desc = "Restart" })

-- PHP-specific DAP mappings
map(
  "n",
  "<leader>dp",
  "<cmd>lua require('dap').run(require('dap').configurations.php[1])<CR>",
  { desc = "Start PHP Xdebug listener" }
)

-- Theme sync mapping
map("n", "<leader>ts", "<cmd>SyncTheme<CR>", { desc = "Sync theme with system" })

-- Git mappings
map("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "LazyGit" })
map("n", "<leader>gs", "<cmd>Git<CR>", { desc = "Git status" })
map("n", "<leader>gb", "<cmd>Git blame<CR>", { desc = "Git blame" })
map("n", "<leader>gF", "<cmd>Gdiffsplit<CR>", { desc = "Git diff split" })

-- Project and session management
map("n", "<leader>fp", "<cmd>Telescope projects<CR>", { desc = "Find projects" })
map("n", "<leader>qs", "<cmd>lua require('persistence').load()<CR>", { desc = "Restore session" })
map("n", "<leader>ql", "<cmd>lua require('persistence').load({ last = true })<CR>", { desc = "Restore last session" })
map("n", "<leader>qd", "<cmd>lua require('persistence').stop()<CR>", { desc = "Stop session recording" })

-- Harpoon mappings
map("n", "<leader>ha", "<cmd>lua require('harpoon'):list():add()<CR>", { desc = "Harpoon add file" })
map(
  "n",
  "<leader>hm",
  "<cmd>lua require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())<CR>",
  { desc = "Harpoon menu" }
)
map("n", "<leader>1", "<cmd>lua require('harpoon'):list():select(1)<CR>", { desc = "Harpoon file 1" })
map("n", "<leader>2", "<cmd>lua require('harpoon'):list():select(2)<CR>", { desc = "Harpoon file 2" })
map("n", "<leader>3", "<cmd>lua require('harpoon'):list():select(3)<CR>", { desc = "Harpoon file 3" })
map("n", "<leader>4", "<cmd>lua require('harpoon'):list():select(4)<CR>", { desc = "Harpoon file 4" })

-- Trouble diagnostics
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Diagnostics (Trouble)" })
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "Buffer Diagnostics (Trouble)" })
map("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<CR>", { desc = "Symbols (Trouble)" })
map(
  "n",
  "<leader>cl",
  "<cmd>Trouble lsp toggle focus=false win.position=right<CR>",
  { desc = "LSP Definitions / references / ... (Trouble)" }
)

-- Enhanced code actions
map("n", "<leader>ca", "<cmd>CodeActionMenu<CR>", { desc = "Code Action Menu" })

-- Refactoring
map(
  "v",
  "<leader>re",
  "<cmd>lua require('refactoring').refactor('Extract Function')<CR>",
  { desc = "Extract Function" }
)
map(
  "v",
  "<leader>rf",
  "<cmd>lua require('refactoring').refactor('Extract Function To File')<CR>",
  { desc = "Extract Function To File" }
)
map(
  "v",
  "<leader>rv",
  "<cmd>lua require('refactoring').refactor('Extract Variable')<CR>",
  { desc = "Extract Variable" }
)
map("v", "<leader>ri", "<cmd>lua require('refactoring').refactor('Inline Variable')<CR>", { desc = "Inline Variable" })

-- Multi-cursor mappings (vim-visual-multi) - for which-key display
map("n", "<leader>mf", "<Plug>(VM-Find-Under)", { desc = "Multi-cursor: Find word under cursor" })
map("n", "<leader>ma", "<Plug>(VM-Select-All)", { desc = "Multi-cursor: Select all occurrences" })
map("n", "<leader>mr", "<Plug>(VM-Start-Regex-Search)", { desc = "Multi-cursor: Regex search" })
map("n", "<leader>mj", "<Plug>(VM-Add-Cursor-Down)", { desc = "Multi-cursor: Add cursor down" })
map("n", "<leader>mk", "<Plug>(VM-Add-Cursor-Up)", { desc = "Multi-cursor: Add cursor up" })
map("n", "<leader>mi", "<Plug>(VM-Add-Cursor-At-Pos)", { desc = "Multi-cursor: Add cursor at position" })
map("n", "<leader>mx", "<Plug>(VM-Skip-Region)", { desc = "Multi-cursor: Skip current selection" })
map("n", "<leader>mp", "<Plug>(VM-Remove-Region)", { desc = "Multi-cursor: Remove current selection" })
map("v", "<leader>mv", "<Plug>(VM-Visual-Cursors)", { desc = "Multi-cursor: Visual to cursors" })
map("v", "<leader>mA", "<Plug>(VM-Visual-All)", { desc = "Multi-cursor: Select all in visual" })
