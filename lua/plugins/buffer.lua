return {
    'akinsho/bufferline.nvim',
    lazy = false,
    dependencies = {
        "nvim-tree/nvim-web-devicons", -- optional, but recommended
    },
    opts = {
        options = {
            mode = "buffers", -- set to "tabs" to only show tabpages instead
            show_buffer_close_icons =  false,
            always_show_bufferline = true,
            show_close_icon = false,
            offsets = {
                {
                    filetype = "neo-tree",   -- o el filetype que tengas
                    text = "Neo-Tree",
                    highlight = "MsgArea",
                    separator = false --o un carácter personalizado
                }
            },
            name_formatter = function(buf)
                local custom = vim.b[buf.bufnr].display_name
                if custom then
                    return custom
                end
                return buf.name
            end,

            get_element_icon = function(element)
                -- Obtenemos el número de buffer a partir de su path
                local bufnr = vim.fn.bufnr(element.path)

                -- Comprobamos si existe la variable buffer_icon en ese buffer
                local icon = vim.b[bufnr].buffer_icon
                local name = vim.b[bufnr].display_name
                if icon then
                    if name == "Bash" or name == "Term" then
                        return icon, "DevIconTerminal"
                    end
                    if name == "OpenCode" then
                        return icon, "DevIconHxx"
                    end
                end

                -- Si no hay icono personalizado, usar el icono por defecto
                local ok, devicons = pcall(require, "nvim-web-devicons")
                if ok then
                    local icon, hl = devicons.get_icon_by_filetype(element.filetype, { default = true })
                    return icon, hl
                end
                return "", ""
            end,
        },
    },
    keys = {
        -- Ir directamente a un buffer usando Alt + número (del 1 al 9)
        { '<A-1>', '<Cmd>BufferLineGoToBuffer 1<CR>'},
        { '<A-2>', '<Cmd>BufferLineGoToBuffer 2<CR>'},
        { '<A-3>', '<Cmd>BufferLineGoToBuffer 3<CR>'},
        { '<A-4>', '<Cmd>BufferLineGoToBuffer 4<CR>'},

        { '<Tab>',   '<Cmd>BufferLineCycleNext<CR>'},
        { '<S-Tab>', '<Cmd>BufferLineCyclePrev<CR>'},

        -- Fijar/desfijar buffer con <leader>bp (ya lo usa LazyVim, pero puedes cambiarlo)
        -- { '<leader>bp', '<Cmd>BufferLineTogglePin<CR>', desc = 'Fijar buffer' },
    },

}
