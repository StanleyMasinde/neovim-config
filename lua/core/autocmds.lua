local api = vim.api

-- Register filetypes
vim.filetype.add {
  pattern = {
    [".*%.blade%.php"] = "blade",
  },
  extension = {
    pug = "pug",
    templ = "templ",
  },
}

-- Highlight text on yank
api.nvim_create_autocmd("TextYankPost", {
  group = api.nvim_create_augroup("YankHighlight", { clear = true }),
  callback = function()
    vim.highlight.on_yank { higroup = "Visual", timeout = 150 }
  end,
})

-- Auto reload file if changed outside Neovim
api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = api.nvim_create_augroup("CheckTime", { clear = true }),
  command = "checktime",
})

-- Resize splits when window resized
api.nvim_create_autocmd("VimResized", {
  group = api.nvim_create_augroup("ResizeSplits", { clear = true }),
  command = "tabdo wincmd =",
})

-- Register blade parser for nvim-treesitter main branch
api.nvim_create_autocmd("User", {
  pattern = "TSUpdate",
  callback = function()
    require("nvim-treesitter.parsers").blade = {
      install_info = {
        url = "https://github.com/EmranMR/tree-sitter-blade",
        files = { "src/parser.c" },
        branch = "main",
      },
      filetype = "blade",
    }
  end,
})

-- Ensure blade filetype maps to the blade parser
vim.treesitter.language.register("blade", "blade")
