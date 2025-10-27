local api = vim.api

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
