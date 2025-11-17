return {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",  -- para actualizar los parsers
    config = function()
        require'nvim-treesitter.configs'.setup {
            highlight = {
                enable = true,                   -- activar resaltado
                additional_vim_regex_highlighting = false,
            },
        }
    end,
}
