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
  attach_to_untracked = true,
  current_line_blame = true,
  on_attach = function(bufnr)
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
    end

    -- Navigation (]c / [c are the usual hunk motions; keep working in :diff)
    map("n", "]c", function()
      if vim.wo.diff then
        vim.cmd.normal { "]c", bang = true }
      else
        gitsigns.nav_hunk "next"
      end
    end, "Next git hunk")

    map("n", "[c", function()
      if vim.wo.diff then
        vim.cmd.normal { "[c", bang = true }
      else
        gitsigns.nav_hunk "prev"
      end
    end, "Previous git hunk")

    -- Actions (under <leader>g, alongside LazyGit)
    map("n", "<leader>gp", gitsigns.preview_hunk, "Preview git hunk")
    map("n", "<leader>gP", gitsigns.preview_hunk_inline, "Preview git hunk inline")
    map("n", "<leader>gs", gitsigns.stage_hunk, "Stage git hunk")
    map("v", "<leader>gs", function()
      gitsigns.stage_hunk { vim.fn.line ".", vim.fn.line "v" }
    end, "Stage git hunk")
    map("n", "<leader>gr", gitsigns.reset_hunk, "Reset git hunk")
    map("v", "<leader>gr", function()
      gitsigns.reset_hunk { vim.fn.line ".", vim.fn.line "v" }
    end, "Reset git hunk")
    map("n", "<leader>gu", gitsigns.undo_stage_hunk, "Undo stage hunk")
    map("n", "<leader>gb", function()
      gitsigns.blame_line { full = true }
    end, "Blame line")
  end,
}
