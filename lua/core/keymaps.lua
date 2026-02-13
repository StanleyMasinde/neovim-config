local map = vim.keymap.set
local opts = { silent = true, noremap = true }

local function get_comment_parts()
  local commentstring = vim.bo.commentstring
  if commentstring == "" or not commentstring:find "%%s" then
    vim.notify("No valid commentstring set for this filetype", vim.log.levels.WARN)
    return nil
  end

  local prefix_raw, suffix_raw = commentstring:match "^(.*)%%s(.*)$"
  local prefix = vim.trim(prefix_raw or "")
  local suffix = vim.trim(suffix_raw or "")
  if prefix == "" then
    vim.notify("Unsupported commentstring for toggle", vim.log.levels.WARN)
    return nil
  end

  return prefix, suffix
end

local function is_commented(content, prefix, suffix)
  local commented = content:match("^" .. vim.pesc(prefix) .. "%s?") ~= nil
  if commented and suffix ~= "" then
    commented = content:match(vim.pesc(suffix) .. "%s*$") ~= nil
  end
  return commented
end

local function toggle_comment_range(start_lnum, end_lnum)
  local prefix, suffix = get_comment_parts()
  if not prefix then
    return
  end

  local lines = vim.api.nvim_buf_get_lines(0, start_lnum - 1, end_lnum, false)
  local nonblank_count = 0
  local all_nonblank_commented = true

  for _, line in ipairs(lines) do
    local _, content = line:match "^(%s*)(.*)$"
    if content ~= "" then
      nonblank_count = nonblank_count + 1
      if not is_commented(content, prefix, suffix) then
        all_nonblank_commented = false
      end
    end
  end

  local should_uncomment = nonblank_count > 0 and all_nonblank_commented
  for i, line in ipairs(lines) do
    local indent, content = line:match "^(%s*)(.*)$"
    if content ~= "" then
      if should_uncomment then
        content = content:gsub("^" .. vim.pesc(prefix) .. "%s?", "", 1)
        if suffix ~= "" then
          content = content:gsub("%s*" .. vim.pesc(suffix) .. "%s*$", "", 1)
        end
      else
        if suffix ~= "" then
          content = prefix .. " " .. content .. " " .. suffix
        else
          content = prefix .. " " .. content
        end
      end
      lines[i] = (indent or "") .. content
    end
  end

  vim.api.nvim_buf_set_lines(0, start_lnum - 1, end_lnum, false, lines)
end

local function toggle_line_comment()
  local line = vim.api.nvim_win_get_cursor(0)[1]
  toggle_comment_range(line, line)
end

-- Basics
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit window" })
map("n", "<leader>h", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
map("n", "<leader>/", toggle_line_comment, { desc = "Toggle comment on current line" })
map("x", "<leader>/", function()
  local start_lnum = vim.fn.getpos "'<"[2]
  local end_lnum = vim.fn.getpos "'>"[2]
  if start_lnum > end_lnum then
    start_lnum, end_lnum = end_lnum, start_lnum
  end
  toggle_comment_range(start_lnum, end_lnum)
end, { desc = "Toggle comment on selection" })

-- Movement
map("n", "J", "mzJ`z", opts)
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)
map("n", "n", "nzzzv", opts)
map("n", "N", "Nzzzv", opts)

-- Quick editing shortcuts
map("n", "<leader>sv", "<cmd>source $MYVIMRC<cr>", { desc = "Reload config" })
map("n", "<leader>rl", "<cmd>lsp restart<cr>", { desc = "Restart LSP" })

-- Tree
map("n", "<leader>e", "<cmd>Neotree float<cr>", { desc = "Focus File Tree" })
map("n", "<leader>tb", "<cmd>Neotree buffers<cr>", { desc = "Show open buffers" })

-- Telescope
map("n", "<leader>fl", "<cmd>Telescope live_grep<cr>", { desc = "Telescope live grep" })
map("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", { desc = "Telescope diagnostics" })

-- LuxTerminal
map("n", "<leader>tt", "<cmd>LuxtermToggle<cr>", { desc = "Luxterm toggle" })

-- Theme
map("n", "<leader>tT", "<cmd>ToggleTheme<CR>", { desc = "Toggle theme" })

-- Buffers
map("n", "<leader>bn", "<cmd>BufferNext<CR>", { desc = "Go to next buffer." })
map("n", "<leader>bp", "<cmd>BufferPrevious<CR>", { desc = "Go to previous buffer." })

-- Legacy mappings.
-- I will update them to match the new ethos
map("i", "jk", "<ESC>")

-- My mapping for LSP functions.
-- Leader key is <space>, so all <leader> mappings start with <space>
-- E.g <space>gd goes to variable definition,
-- <space>ac will show code actions
-- <space>er will jump to the next error and show it in details
-- PHP specific: <space>pf formats PHP files

-- LSP mappings
map("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "<leader>ac", vim.lsp.buf.code_action, { desc = "Code actions" })
map("n", "<leader>er", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

-- PHP specific mapping
map("n", "<leader>pf", function()
  require("conform").format { lsp_fallback = true }
end, { desc = "Format PHP file" })

-- Format file
map("n", "<leader>fm", function()
  require("conform").format { lsp_fallback = true }
end, { desc = "Format file" })

-- Theme sync mapping
map("n", "<leader>ts", "<cmd>SyncTheme<CR>", { desc = "Sync theme with system" })

-- Git mappings
map("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "LazyGit" })
