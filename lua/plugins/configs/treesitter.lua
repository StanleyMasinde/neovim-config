-- nvim-treesitter main branch: install parsers only.
-- Highlighting/indent are enabled via Neovim APIs (see FileType autocmd below).
local parsers = {
  "lua",
  "rust",
  "bash",
  "json",
  "yaml",
  "toml",
  "vim",
  "markdown",
  "markdown_inline",
  "blade",
  "php",
  "html",
  "css",
  "javascript",
  "typescript",
  "tsx",
  "vue",
}

require("nvim-treesitter").install(parsers)

-- Enable treesitter highlight (and experimental indent) for every filetype
-- that has a parser available. Built-in ftplugins already start lua/markdown/etc.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("TreesitterHighlight", { clear = true }),
  callback = function(ev)
    local ok = pcall(vim.treesitter.start)
    if not ok then
      return
    end
    -- Experimental treesitter indent (safe no-op if module missing)
    vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
