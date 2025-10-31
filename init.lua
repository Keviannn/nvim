require("kevia.settings")
require("kevia.lazy")

local k = vim.keymap
local api = vim.api

-- CONFIGURACIÓN TERMINAL / TERMINAL CONFIGURATION --

-- Variable que almacena el buffer de la terminal (no la ventana) / Variable that stores the terminal buffer (not the window)
local term_buf = nil
local term_win = nil

local function toggle_terminal()
    -- Si la ventana de la terminal sigue abierta, ciérrala (ocúltala) / If the terminal window is still open, close it (hide it)
    if term_win and api.nvim_win_is_valid(term_win) then
        api.nvim_win_hide(term_win)
        term_win = nil
        return
    end

    -- Si no hay buffer de terminal válido, créalo / If there is no valid terminal buffer, create it
    if not term_buf or not api.nvim_buf_is_valid(term_buf) then
        vim.cmd('botright 10split')
        vim.cmd('terminal')
        term_win = api.nvim_get_current_win()
        term_buf = api.nvim_get_current_buf()
        api.nvim_buf_set_name(term_buf, "Terminal")
    else
        -- Si el buffer existe, simplemente lo volvemos a mostrar / if the buffer exists, just show it again
        vim.cmd('botright 10split')
        term_win = api.nvim_get_current_win()
        api.nvim_win_set_buf(term_win, term_buf)
    end

    vim.cmd('startinsert')
end

-- CONFIGURACIÓN NAVITERM / NAVITERM CONFIGURATION --
local naviterm_buf = nil
local prev_buf = nil

local function open_naviterm()

    -- Tomo el buffer actual / Get the current buffer
    local in_buf = api.nvim_get_current_buf()

    -- Si el buffer de naviterm existe, es válido... / If the naviterm buffer exists and is valid...
    if naviterm_buf and api.nvim_buf_is_valid(naviterm_buf) then

        -- ... y es el actual / ...and it is the current buffer
        if naviterm_buf == in_buf then
            -- Cambia al buffer previo / Switch to the previous buffer
            api.nvim_set_current_buf(prev_buf)
            return
        end

        -- ... y no es el actual / ... and it is not the current buffer

        -- Actualiza el buffer previo / Update the previous buffer
        prev_buf = in_buf

        -- Y cambia al buffer de naviterm / And switch to the naviterm buffer
        api.nvim_set_current_buf(naviterm_buf)
        return
    end

    -- Si el buffer de naviterm no existe o no es válido (Primera iteración) / If the naviterm buffer does not exist or is not valid (first iteration)

    -- El buffer actual se convierte en el previo / Set the current buffer as the previous buffer
    prev_buf = in_buf

    -- Y se llama a naviterm, se setea su id en naviterm_buf y se le da un nombre al buffer / Call naviterm, set its id in naviterm_buf, and give the buffer a name
    vim.cmd('terminal naviterm')
    naviterm_buf = api.nvim_get_current_buf()
    api.nvim_buf_set_name(naviterm_buf, "Naviterm")
end


-- ATAJOS CUSTOM --
-- leader se cambia en lazy.lua
k.set('n', '<leader>f', ':Telescope find_files<CR>', { desc = 'Buscar archivos con Telescope / Find file with Telescope', silent = true})
k.set('n', '<leader>g', ':Telescope git_files<CR>', { desc = 'Buscar archivos de git con Telescope / Find git files with Telescope', silent = true})
k.set('n', '<leader>l', ':Lazy<CR>', { desc = 'Abre LazyLim / Opens LazyVim', silent = true })
k.set({'n', 'v'}, ' ', ':', { desc = 'Espacio es ahora : / Change : to space key' })
k.set('n', '<leader>qq', ':q!<CR>', {desc = 'Cerrar sin guardar más fácil / Close easier without saving', silent = true })
k.set('n', '<leader>m', ':Mason<CR>', {desc = 'Abrir Mason / Open Mason', silent = true })
k.set('n', '<leader>w', '<C-w>', {desc = "Cambiar ventanas / Change windows", silent = true })
k.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Enseñar errores del LSP / Show LSP errors", silent = true  })
k.set('n', '<leader>h', ':Telescope harpoon marks<CR>', {desc = "Abrir marks de telescope y harpoon / Opens harpoon marks in Telescope", silent = true })
k.set({'v','n'}, 'á', '"', { desc = "Cambia la combinacion para poner comillas con á / Changes the \" combination with á", silent = true }) -- Más fácil seleccionar buffers / Easier to select buffers
k.set('t', '<Esc>', [[<C-\><C-n>]], { desc = "Sale del modo inserción en terminal / Gets out of insert mode in terminal mode", silent = true })
k.set('n', '<leader>t', toggle_terminal, { desc = "Abrir/Cerrar la terminal / Open/Close terminal", silent = true })
k.set({'n', 'v', 'i'}, '<Up>', '<Nop>', { desc = "Impide usar las flechas / Blocks arrows" })
k.set({'n', 'v', 'i'}, '<Down>', '<Nop>', { desc = "Impide usar las flechas / Blocks arrows" })
k.set({'n', 'v', 'i'}, '<Left>', '<Nop>', { desc = "Impide usar las flechas / Blocks arrows" })
k.set({'n', 'v', 'i'}, '<Right>', '<Nop>', { desc = "Impide usar las flechas / Blocks arrows" })
k.set('n', '<Esc>', ':noh<CR>', { desc = "Esc me quita el highlight de búsqueda / Esc hides search highlight", silent = true })
k.set('n', '<leader>n', open_naviterm, { desc = "Abrir naviterm / Opens naviterm", silent = true })


-- ATAJOS DEBUGGER --
local dap = require("dap")
local dapui = require("dapui")
local dapvt = require("nvim-dap-virtual-text")

k.set("n", "<leader>dt", dap.toggle_breakpoint, { desc = "Toggle Breakpoint", noremap = true, silent = true })
k.set("n", "<leader>dc", dap.continue, { desc = "Continue", noremap = true, silent = true })
k.set("n", "<leader>di", dap.step_into, { desc = "Step Into", noremap = true, silent = true })
k.set("n", "<leader>do", dap.step_over, { desc = "Step Over", noremap = true, silent = true })
k.set("n", "<leader>du", dap.step_out, { desc = "Step Out", noremap = true, silent = true })
k.set("n", "<leader>dr", dap.repl.open, { desc = "Open REPL", noremap = true, silent = true })
k.set("n", "<leader>dl", dap.run_last, { desc = "Run Last", noremap = true, silent = true })
k.set("n", "<leader>db", dap.list_breakpoints, { desc = "List Breakpoints", noremap = true, silent = true })

k.set("n", "<leader>dq", function()
  dap.terminate()
  dapui.close()
  dapvt.toggle()
end, { desc = "Terminate", noremap = true, silent = true })

k.set("n", "<leader>de", function()
  dap.set_exception_breakpoints({ "all" })
end, { desc = "Set Exception Breakpoints", noremap = true, silent = true })


-- CAMBIAR COMO SE VEN LOS COMENTARIOS TODO / CHANGES HOW TODO COMMENTS LOOK --
api.nvim_set_hl(0, "Todo", {fg = "#7fbfff", bg = "NONE", italic = true})
