local gitsigns = require "gitsigns"

gitsigns.setup {
  signs = {
    add = { text = "│" },
    change = { text = "│" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
  },
  numhl = false,
  linehl = false,
  watch_gitdir = { interval = 1000 },
  attach_to_untracked = true,
  current_line_blame = true,
}
