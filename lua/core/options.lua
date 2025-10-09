local opt = vim.opt
local g = vim.g

-- Core UI
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.termguicolors = true

-- Indentation
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

-- Splits
opt.splitbelow = true
opt.splitright = true

-- Clipboard + Mouse
opt.mouse = "a"
opt.clipboard = "unnamedplus"

-- Performance
opt.updatetime = 250
opt.timeoutlen = 400
opt.lazyredraw = true
opt.shell = "/bin/zsh"

-- New Neovim defaults (0.10+)
opt.fillchars = { eob = " ", fold = " ", foldopen = "", foldclose = "" }
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldenable = false

-- Leader
g.mapleader = " "
g.maplocalleader = ","
