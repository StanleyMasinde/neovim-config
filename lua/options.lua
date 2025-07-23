require "nvchad.options"

-- add yours here!

local o = vim.o
local opt = vim.opt

-- Better editing experience
o.cursorlineopt = 'both' -- Enable cursorline
opt.relativenumber = true -- Relative line numbers
opt.scrolloff = 8 -- Keep 8 lines above/below cursor
opt.sidescrolloff = 8 -- Keep 8 columns left/right of cursor
opt.wrap = false -- Don't wrap lines

-- Better search
opt.ignorecase = true -- Ignore case in search
opt.smartcase = true -- Case sensitive if uppercase letters
opt.hlsearch = true -- Highlight search results
opt.incsearch = true -- Incremental search

-- Better indentation
opt.expandtab = true -- Use spaces instead of tabs
opt.shiftwidth = 2 -- Indent width
opt.tabstop = 2 -- Tab width
opt.softtabstop = 2 -- Soft tab width
opt.smartindent = true -- Smart autoindenting

-- Better completion
opt.completeopt = {'menu', 'menuone', 'noselect'}
opt.updatetime = 250 -- Faster completion
opt.timeoutlen = 300 -- Faster key sequence timeout

-- Better splits
opt.splitbelow = true -- Horizontal splits below
opt.splitright = true -- Vertical splits to the right

-- Better backup and undo
opt.backup = false -- Don't create backup files
opt.swapfile = false -- Don't create swap files
opt.undofile = true -- Enable persistent undo
opt.undolevels = 10000

-- Better UI
opt.signcolumn = "yes" -- Always show sign column
opt.termguicolors = true -- Enable 24-bit RGB colors
opt.showmode = false -- Don't show mode (shown in statusline)
opt.conceallevel = 2 -- Hide markup characters

-- Better performance
opt.lazyredraw = true -- Don't redraw during macros
opt.regexpengine = 1 -- Use old regex engine for better performance
