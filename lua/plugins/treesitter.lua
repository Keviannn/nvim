return {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",      -- Actualiza lenguajes / Update languajes
    config = function()
        require'nvim-treesitter.configs'.setup {
            highlight = {
                enable = true,     -- Activa los colores de treesitter / Enables treesitter coloring
                additional_vim_regex_highlighting = false,
            },
        }
    end,
}
