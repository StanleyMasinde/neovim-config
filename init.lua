if vim.loader then
    vim.loader.enable()
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("core.options")
require("core.keymaps")
require("core.autocmds")
require("core.cmds")

require("lazy").setup("plugins", {
    ui = { border = "rounded" },
    change_detection = { enabled = true, notify = false },
})


vim.diagnostic.config({
    virtual_text = {
        prefix = "●", -- small dot looks clean
        spacing = 2,
        source = "if_many", -- show source name if multiple
    },
    signs = true,
    underline = true,
    update_in_insert = false, -- don’t spam while typing
    severity_sort = true,
})
