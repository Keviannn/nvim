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
        end, { desc = "Harpoon: Añadir archivo" })

        vim.keymap.set("n", "<leader>j", function()
            harpoon.ui:toggle_quick_menu(list)
        end, { desc = "Harpoon: Menú rápido" })

        vim.keymap.set("n", "<C-h>", function() list:select(1) end, { desc = "Harpoon: Archivo 1" })
        vim.keymap.set("n", "<C-t>", function() list:select(2) end, { desc = "Harpoon: Archivo 2" })
        vim.keymap.set("n", "<C-n>", function() list:select(3) end, { desc = "Harpoon: Archivo 3" })
        vim.keymap.set("n", "<C-s>", function() list:select(4) end, { desc = "Harpoon: Archivo 4" })
    end,
}
