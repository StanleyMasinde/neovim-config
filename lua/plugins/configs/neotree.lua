require("neo-tree").setup({
    close_if_last_window = true, 
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = true,
    default_component_configs = {
        icon = { folder_closed = "", folder_open = "", folder_empty = "" },
        name = { trailing_slash = false },
        git_status = { symbols = { added = "", modified = "", removed = "" } },
        diagnostics = { symbols = { hint = "", info = "", warning = "", error = "" } },
    },
    window = {
        position = "left",
        width = 35,
        mappings = {
            ["<space>"] = "toggle_node",
            ["<cr>"] = "open",
            ["S"] = "open_split",
            ["s"] = "open_vsplit",
            ["<esc>"] = "revert_preview",
            ["a"] = "add",
            ["d"] = "delete",
            ["r"] = "rename",
        },
    },
    filesystem = {
        follow_current_file = true,
        use_libuv_file_watcher = true,
        hijack_netrw_behavior = "open_default",
    },
})
