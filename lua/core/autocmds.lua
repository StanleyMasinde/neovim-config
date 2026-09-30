local api = vim.api

-- Highlight text on yank
api.nvim_create_autocmd("TextYankPost", {
  group = api.nvim_create_augroup("YankHighlight", { clear = true }),
  callback = function()
    vim.hl.on_yank { higroup = "Visual", timeout = 150 }
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
  callback = function()
    local current_win = api.nvim_get_current_win()
    for _, tab in ipairs(api.nvim_list_tabpages()) do
      local win = api.nvim_tabpage_get_win(tab)
      api.nvim_win_call(win, function()
        vim.cmd "wincmd ="
      end)
    end
    if api.nvim_win_is_valid(current_win) then
      api.nvim_set_current_win(current_win)
    end
  end,
})
