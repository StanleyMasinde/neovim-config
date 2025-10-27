local M = {}

-- Helper for LSP diagnostics
local function lsp_diagnostics()
  local diag = vim.diagnostic.get(0)
  local counts = { E = 0, W = 0, H = 0, I = 0 }
  for _, d in ipairs(diag) do
    if d.severity == vim.diagnostic.severity.ERROR then
      counts.E = counts.E + 1
    elseif d.severity == vim.diagnostic.severity.WARN then
      counts.W = counts.W + 1
    elseif d.severity == vim.diagnostic.severity.HINT then
      counts.H = counts.H + 1
    elseif d.severity == vim.diagnostic.severity.INFO then
      counts.I = counts.I + 1
    end
  end
  local parts = {}
  if counts.E > 0 then
    table.insert(parts, " " .. counts.E)
  end
  if counts.W > 0 then
    table.insert(parts, " " .. counts.W)
  end
  if counts.H > 0 then
    table.insert(parts, " " .. counts.H)
  end
  if counts.I > 0 then
    table.insert(parts, " " .. counts.I)
  end
  return table.concat(parts, " ")
end

-- Main statusline function
function M.get()
  local mode = ("%s"):format(vim.api.nvim_get_mode().mode)
  local fname = vim.fn.expand "%:t"
  local git = vim.b.gitsigns_status or ""
  local diag = lsp_diagnostics()
  local pos = string.format("%d:%d", vim.fn.line ".", vim.fn.col ".")
  return table.concat({ " " .. mode .. " ", fname, " " .. git .. " ", diag, pos }, " | ")
end
