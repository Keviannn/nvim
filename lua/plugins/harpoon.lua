return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    config = function()
        local harpoon = require("harpoon")

        harpoon:setup({
            settings = {
                save_on_toggle = true,
                sync_on_ui_close = true,
            }
        })

        local list = harpoon:list()

        vim.keymap.set("n", "<leader>a", function()
            list:add()
        end, { desc = "Harpoon: Añadir archivo / Add file" })

        vim.keymap.set("n", "<leader>j", function()
            harpoon.ui:toggle_quick_menu(list)
        end, { desc = "Harpoon: Menú rápido / Fast menu" })
    end,
}
