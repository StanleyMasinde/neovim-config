-- Run from the config directory: nvim --clean --headless -i NONE -l tests/config_spec.lua
local root = vim.fn.getcwd()
vim.opt.rtp:prepend(root)
vim.opt.rtp:append(vim.fn.stdpath "data" .. "/lazy/conform.nvim")
local config = require "plugins.configs.conform"
local tmp = vim.fn.tempname()
vim.fn.mkdir(tmp, "p")

local function equal(actual, expected, label)
  assert(vim.deep_equal(actual, expected), label .. ": " .. vim.inspect(actual))
end

local function project(name, package_json, files)
  local dir = tmp .. "/" .. name
  vim.fn.mkdir(dir .. "/src", "p")
  if package_json then
    vim.fn.writefile({ package_json }, dir .. "/package.json")
  end
  for _, file in ipairs(files or {}) do
    vim.fn.writefile({ "{}" }, dir .. "/" .. file)
  end
  return dir
end

local function select_formatters(dir, ft)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(buf, dir .. "/src/example." .. ft)
  vim.bo[buf].filetype = ft
  local selected = config.formatters_by_ft[ft](buf)
  vim.api.nvim_buf_delete(buf, { force = true })
  return selected
end

local plain = project("plain", "{}")
local oxlint = project("oxlint", '{"devDependencies":{"oxlint":"*"}}')
local eslint = project("eslint", "{}", { "eslint.config.js" })
local oxc = project("oxc", '{"devDependencies":{"oxlint":"*","oxfmt":"*","prettier":"*"}}', { "eslint.config.js" })
equal(select_formatters(plain, "javascript"), { "prettier" }, "default formatter")
equal(select_formatters(oxlint, "typescript"), { "oxlint", "prettier" }, "lint plus fallback")
equal(select_formatters(eslint, "vue"), { "eslint_fix", "prettier" }, "ESLint plus fallback")
equal(select_formatters(oxc, "javascriptreact"), { "oxlint", "oxfmt" }, "Oxc preference")
for _, ft in ipairs { "css", "scss", "html", "json", "jsonc" } do
  equal(select_formatters(oxlint, ft), { "prettier" }, ft .. " excludes Oxlint")
  equal(select_formatters(eslint, ft), { "prettier" }, ft .. " excludes ESLint")
  equal(select_formatters(oxc, ft), { "oxfmt" }, ft .. " uses Oxfmt")
end
local invalid = project("invalid", "{")
equal(select_formatters(invalid, "javascript"), { "prettier" }, "malformed manifest fallback")
local legacy = project("legacy", '{"eslintConfig":{}}')
equal(select_formatters(legacy, "typescriptreact"), { "eslint_fix", "prettier" }, "legacy config")
local configured = project("configured", nil, { ".oxlintrc.json", ".oxfmtrc.json" })
equal(select_formatters(configured, "vue"), { "oxlint", "oxfmt" }, "config-only project")
for _, field in ipairs { "dependencies", "optionalDependencies", "peerDependencies" } do
  local dir = project(field, vim.json.encode { [field] = { oxfmt = "*" } })
  equal(select_formatters(dir, "javascript"), { "oxfmt" }, field)
end
-- A project change must be picked up without restarting or invalidating a cache.
vim.fn.writefile({ '{"devDependencies":{"oxfmt":"*"}}' }, plain .. "/package.json")
equal(select_formatters(plain, "javascript"), { "oxfmt" }, "manifest changes")
local original_readfile, reads = vim.fn.readfile, 0
vim.fn.readfile = function(...)
  reads = reads + 1
  return original_readfile(...)
end
select_formatters(oxlint, "javascript")
vim.fn.readfile = original_readfile
equal(reads, 1, "one manifest read per selection")

require "core.autocmds"
for _, ft in ipairs { "blade", "pug", "templ" } do
  local filename = ft == "blade" and "test.blade.php" or "test." .. ft
  equal(vim.filetype.match { filename = filename }, ft, "native filetype")
end
vim.cmd "vsplit"
vim.cmd "vertical resize 10"
local first_tab = vim.api.nvim_get_current_tabpage()
vim.cmd "tabnew"
vim.cmd "vsplit"
vim.cmd "vertical resize 10"
vim.api.nvim_set_current_tabpage(first_tab)
local first_win = vim.api.nvim_get_current_win()
vim.api.nvim_exec_autocmds("VimResized", {})
equal(vim.api.nvim_get_current_tabpage(), first_tab, "resize preserves tab")
equal(vim.api.nvim_get_current_win(), first_win, "resize preserves window")
for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
  local wins = vim.api.nvim_tabpage_list_wins(tab)
  assert(math.abs(vim.api.nvim_win_get_width(wins[1]) - vim.api.nvim_win_get_width(wins[2])) <= 1, "equal split widths")
end

local heirline_config
package.loaded.heirline = {
  setup = function(opts)
    heirline_config = opts
  end,
}
package.loaded["heirline.conditions"] = {}
require "plugins.configs.heirline"
vim.api.nvim_buf_set_name(0, tmp .. "/a%b.lua")
local filename_provider = heirline_config.statusline[2].provider
equal(vim.api.nvim_eval_statusline(filename_provider, {}).str, " a%b.lua ", "literal filename")
local branch_provider = heirline_config.statusline[3][1].provider
equal(vim.api.nvim_eval_statusline(branch_provider { branch = "fix%bug" }, {}).str, "  fix%bug(", "literal branch")
vim.fn.delete(tmp, "rf")
print "Config regression checks passed"
