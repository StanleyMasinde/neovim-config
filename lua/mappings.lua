require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- My mapping for LSP functions.
-- Leader key is <space>, so all <leader> mappings start with <space>
-- E.g <space>gd goes to variable definition,
-- <space>ac will show code actions
-- <space>er will jump to the next error and show it in details

-- LSP mappings
map("n", "<leader>gd", "<cmd>lua vim.lsp.buf.definition()<CR>", 
  { desc = "Go to definition" })
map("n", "<leader>ac", "<cmd>lua vim.lsp.buf.code_action()<CR>", 
  { desc = "Code actions" })
map("n", "<leader>er", "<cmd>lua vim.diagnostic.goto_next()<CR>", 
  { desc = "Next diagnostic" })

-- ESLint specific mappings
map("n", "<leader>ef", "<cmd>EslintFixAll<CR>", 
  { desc = "ESLint fix all" })
map("n", "<leader>el", "<cmd>lua require('lint').try_lint()<CR>", 
  { desc = "Run ESLint" })

-- Format file
map("n", "<leader>fm", "<cmd>lua require('conform').format({ lsp_fallback = true })<CR>", 
  { desc = "Format file" })

-- DAP (Debugger) mappings
map("n", "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<CR>", 
  { desc = "Toggle Breakpoint" })
map("n", "<leader>dc", "<cmd>lua require('dap').continue()<CR>", 
  { desc = "Continue" })
map("n", "<leader>dso", "<cmd>lua require('dap').step_over()<CR>", 
  { desc = "Step Over" })
map("n", "<leader>dsi", "<cmd>lua require('dap').step_into()<CR>", 
  { desc = "Step Into" })
map("n", "<leader>dsO", "<cmd>lua require('dap').step_out()<CR>", 
  { desc = "Step Out" })
map("n", "<leader>dr", "<cmd>lua require('dap.repl').open()<CR>", 
  { desc = "Open REPL" })
map("n", "<leader>dt", "<cmd>lua require('dapui').toggle()<CR>", 
  { desc = "Toggle DAP UI" })
map("n", "<leader>dx", "<cmd>lua require('dap').terminate()<CR>", 
  { desc = "Terminate" })
map("n", "<leader>dR", "<cmd>lua require('dap').restart()<CR>", 
  { desc = "Restart" })

-- Theme sync mapping
map("n", "<leader>ts", "<cmd>SyncTheme<CR>", 
  { desc = "Sync theme with system" })

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
map("n", "<leader>hm", "<cmd>lua require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())<CR>", { desc = "Harpoon menu" })
map("n", "<leader>1", "<cmd>lua require('harpoon'):list():select(1)<CR>", { desc = "Harpoon file 1" })
map("n", "<leader>2", "<cmd>lua require('harpoon'):list():select(2)<CR>", { desc = "Harpoon file 2" })
map("n", "<leader>3", "<cmd>lua require('harpoon'):list():select(3)<CR>", { desc = "Harpoon file 3" })
map("n", "<leader>4", "<cmd>lua require('harpoon'):list():select(4)<CR>", { desc = "Harpoon file 4" })

-- Trouble diagnostics
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Diagnostics (Trouble)" })
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "Buffer Diagnostics (Trouble)" })
map("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<CR>", { desc = "Symbols (Trouble)" })
map("n", "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<CR>", { desc = "LSP Definitions / references / ... (Trouble)" })

-- Enhanced code actions
map("n", "<leader>ca", "<cmd>CodeActionMenu<CR>", { desc = "Code Action Menu" })

-- Refactoring
map("v", "<leader>re", "<cmd>lua require('refactoring').refactor('Extract Function')<CR>", { desc = "Extract Function" })
map("v", "<leader>rf", "<cmd>lua require('refactoring').refactor('Extract Function To File')<CR>", { desc = "Extract Function To File" })
map("v", "<leader>rv", "<cmd>lua require('refactoring').refactor('Extract Variable')<CR>", { desc = "Extract Variable" })
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

-- Multi-cursor mappings (vim-visual-multi)
-- NOTE: Leader key is <space>, so all <leader> mappings start with <space>
-- Multi-cursor specific keys using <leader>m prefix:
-- <space>mf     = Find word under cursor and add to selection
-- <space>ma     = Select all occurrences of word under cursor
-- <space>mr     = Start regex search for multi-cursor selection
-- <space>mj     = Add cursor down (vertical multi-cursor)
-- <space>mk     = Add cursor up (vertical multi-cursor)
-- <space>mi     = Add cursor at current position
-- <space>mx     = Skip current selection and find next
-- <space>mp     = Remove current selection
-- <space>mv     = Convert visual selection to multiple cursors
-- <space>mA     = Select all in visual selection
-- In multi-cursor mode:
--   - Type normally to edit all cursors
--   - <Esc> to exit multi-cursor mode
--   - u/Ctrl-r for undo/redo
-- NOTE: Multi-cursor is automatically disabled in nvim-tree and other file explorers

-- Uncomment to enable Ctrl+S save in all modes
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>", { desc = "Save file" })
