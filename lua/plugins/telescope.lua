return {
    "nvim-telescope/telescope.nvim",
    config = function()
        require("telescope").setup{
            defaults = {
                -- initial_mode = "normal",
                hidden = true,
            },
            pickers = {
                find_files = {
                    hidden = true, -- no ignora archivos ocultos
                    no_ignore = true, -- no ignora .gitignore
                },
                git_files = {
                    hidden = true,
                    show_untracked = true,
                    prompt_title = "Git Files",
                }
            },
        }
        require("telescope").load_extension('harpoon')
    end,
}
