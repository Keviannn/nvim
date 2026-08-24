return {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        files = {
            hidden = true,
            no_ignore = true,
        },
        buffers = {
            sort_lastused = true,
            show_unloaded = false,
        }
    }
}
