require('neo-tree').setup {
    disable_netrw = true,
    hijack_netrw = true,
    auto_close = true,
    open_on_setup = false,
    open_on_tab = false,
    hijack_cursor = true,
    update_cwd = true,
    lsp_diagnostics = true,
    update_focused_file = {
        enable = true,
        update_cwd = true,
        ignore_list = {}
    },
    system_open = {
        cmd = nil,
        args = {}
    },
    view = {
        width = 30,
        side = 'left',
        auto_resize = false,
        mappings = {
            custom_only = false,
            list = {}
        }
    },
    filesystem = {
        filtered_items = {
            visible = true,
            hide_dotfiles = false,
            hide_gitignore = true
        },
    }
}
