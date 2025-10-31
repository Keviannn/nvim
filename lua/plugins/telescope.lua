return {
    "nvim-telescope/telescope.nvim",
    config = function()
        require("telescope").setup{
            defaults = {
                hidden = true, -- muestra archivos ocultos predeterminado / show hidden files as a default config
            },
            pickers = {
                find_files = {
                    hidden = true, -- no ignora archivos ocultos / show hidden files
                    no_ignore = true, -- no ignora .gitignore / show .gitignore files
                },
                git_files = {
                    hidden = true,
                    show_untracked = true,
                    prompt_title = "Git Files",
                }
            },
        }
        require("telescope").load_extension('harpoon') -- harpoon funciona como extensión de telescope / harpoon as a telescope extension
    end,
}
