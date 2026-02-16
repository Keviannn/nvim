return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-telescope/telescope-file-browser.nvim",
    },
    config = function()
        require("telescope").setup{
            defaults = {
                hidden = true, -- muestra archivos ocultos predeterminado / show hidden files as a default config
                file_ignore_patterns = {
                    "%.git/",
                    "%.o$",
                    "%.png$",
                    "%.class$",
                    "%.jpeg$",
                },
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
            extensions = {
                file_browser = {
                    hidden = true,
                    grouped = true,        -- agrupa carpetas arriba
                    previewer = false,     -- más estilo Vex
                    layout_strategy = "vertical",
                    layout_config = {
                        height = 0.95,
                        width = 0.6,
                        prompt_position = "top",
                    },
                },
            },
        }
        require("telescope").load_extension('file_browser') -- carga la extensión del navegador de archivos / load the file browser extension
    end,
}
