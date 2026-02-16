return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-tree/nvim-web-devicons", -- optional, but recommended
    },
    lazy = false, -- neo-tree will lazily load itself
    config = function()
        require("neo-tree").setup({
            filesystem = {
                filtered_items = {
                    visible = true, -- muestra archivos ocultos si quieres
                },
                group_empty_dirs = true,
                persist_state = true, -- que recuerde las carpetas abiertas
            },
            window = {
                position = "left", -- izquierda
                width = 30,        -- ancho en columnas
                mapping_options = {
                    noremap = true,
                    nowait = true,
                },
            }
        })
    end,
}
