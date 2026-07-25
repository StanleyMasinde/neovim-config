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
-- smartindent omitted: treesitter indentexpr handles most filetypes

-- Search (incsearch/hlsearch are defaults; keep case options)
opt.ignorecase = true
opt.smartcase = true

-- Splits
opt.splitbelow = true
opt.splitright = true

-- Clipboard + Mouse
opt.mouse = ""
opt.clipboard = "unnamedplus"

-- Performance
opt.updatetime = 250
opt.timeoutlen = 400
-- lazyredraw removed: causes UI glitches with modern Neovim
opt.shell = "/bin/zsh"

-- Folds (treesitter; disabled until opened)
opt.fillchars = { eob = " ", fold = " ", foldopen = "", foldclose = "" }
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldenable = false

-- Leader (must be set before lazy.nvim loads plugins)
g.mapleader = " "
g.maplocalleader = ","

vim.o.laststatus = 3
vim.o.showmode = false
vim.o.ruler = false

-- Allow project-local config (.nvim.lua / .exrc)
vim.o.exrc = true

-- Quiet LSP logs unless debugging
vim.lsp.log.set_level(vim.log.levels.OFF)
