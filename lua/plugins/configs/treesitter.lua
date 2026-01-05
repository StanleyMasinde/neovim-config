require'nvim-treesitter'.setup {
  ensure_installed = {
    "lua",
    "rust",
    "bash",
    "json",
    "yaml",
    "toml",
    "vim",
    "markdown",
  },
  highlight = { enable = true },
  indent = { enable = true },
  incremental_selection = { enable = true },
}
