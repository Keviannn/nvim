require("user.settings")
require("user.lazy")

local k = vim.keymap
local api = vim.api

vim.g.cmp_enabled = true

-- CONFIGURACIÓN TERMINAL / TERMINAL CONFIGURATION --

-- Variable que almacena el buffer de la terminal (no la ventana) / Variable that stores the terminal buffer (not the window)
local term_buf = nil
local term_win = nil

local function toggle_terminal_window()
    -- Si la ventana de la terminal sigue abierta, ciérrala (ocúltala) / If the terminal window is still open, close it (hide it)
    if term_win and api.nvim_win_is_valid(term_win) then
        api.nvim_win_hide(term_win)
        term_win = nil
        return
    end

    -- Si no hay buffer de terminal válido, créalo / If there is no valid terminal buffer, create it
    if not term_buf or not api.nvim_buf_is_valid(term_buf) then
        vim.cmd('split')
        vim.cmd('resize 10')
        vim.cmd('terminal')
        term_win = api.nvim_get_current_win()
        term_buf = api.nvim_get_current_buf()
        api.nvim_buf_set_name(term_buf, "Terminal")
    else
        -- Si el buffer existe, simplemente lo volvemos a mostrar / if the buffer exists, just show it again
        vim.cmd('split')
        vim.cmd('resize 10')
        term_win = api.nvim_get_current_win()
        api.nvim_win_set_buf(term_win, term_buf)
    end

    vim.cmd('startinsert')
end

local function open_terminal()

    -- Tomo el buffer actual / Get the current buffer
    local in_buf = api.nvim_get_current_buf()

    -- Si el buffer de la terminal existe, es válido... / If the terminal buffer exists and is valid...
    if term_buf and api.nvim_buf_is_valid(term_buf) then

        -- ... y es el actual / ...and it is the current buffer
        if term_buf == in_buf then
            -- Cambia al buffer previo / Switch to the previous buffer
            api.nvim_set_current_buf(prev_buf)
            return
        end

        -- ... y no es el actual / ... and it is not the current buffer

        -- Actualiza el buffer previo / Update the previous buffer
        prev_buf = in_buf

        -- Y cambia al buffer de la terminal / And switch to the terminal buffer
        api.nvim_set_current_buf(term_buf)
        vim.cmd('startinsert')
        return
    end

    -- Si el buffer de la terminal no existe o no es válido (Primera iteración) / If the terminal buffer does not exist or is not valid (first iteration)

    -- El buffer actual se convierte en el previo / Set the current buffer as the previous buffer
    prev_buf = in_buf

    -- Y se llama a la terminal, se setea su id en term_buf y se le da un nombre al buffer / Call terminal, set its id in term_buf, and give the buffer a name
    vim.cmd('terminal')
    vim.cmd('startinsert')
    term_buf = api.nvim_get_current_buf()
    api.nvim_buf_set_name(term_buf, "Terminal")
end

-- Activa ratón / enables mouse
local function enable_mouse()
    vim.opt.mouse = "a"
end

-- Desactiva ratón / disables mouse 
local function disable_mouse()
    vim.opt.mouse = ""
end

-- CONFIGURACIÓN OPENCODE / OPENCODE CONFIGURATION --
local code_buf = nil
local code_win = nil

-- Autocomando: al entrar a la ventana de OpenCode, activar mouse y modo insertar
-- Autocommand: on opencode, enable mouse and put insert mode
vim.api.nvim_create_autocmd("WinEnter", {
    callback = function()
        if code_win and vim.api.nvim_win_is_valid(code_win) then
            local current_win = vim.api.nvim_get_current_win()
            if current_win == code_win then
                enable_mouse()
                vim.cmd('startinsert')
            end
        end
    end,
})

-- Autocomando: al salir de la ventana de OpenCode, desactivar mouse
-- Autocommand: out of opencode, disable mouse
vim.api.nvim_create_autocmd("WinLeave", {
    callback = function()
        if code_win and vim.api.nvim_win_is_valid(code_win) then
            local left_win = vim.api.nvim_get_current_win() -- la ventana a la que se sale
            if left_win == code_win then
                disable_mouse()
            end
        end
    end,
})

local function toggle_opencode_window()
    -- Si la ventana de la terminal sigue abierta, ciérrala (ocúltala) / If the terminal window is still open, close it (hide it)
    if code_win and api.nvim_win_is_valid(code_win) then
        api.nvim_win_hide(code_win)
        code_win = nil
        disable_mouse()
        return
    end

    -- Si no hay buffer de terminal válido, créalo / If there is no valid terminal buffer, create it
    if not code_buf or not api.nvim_buf_is_valid(code_buf) then
        vim.cmd('vsplit')
        vim.cmd('wincmd L')
        vim.cmd('vertical resize 50')
        vim.cmd('terminal opencode')
        code_win = api.nvim_get_current_win()
        code_buf = api.nvim_get_current_buf()
        api.nvim_buf_set_name(code_buf, "OpenCode")
        enable_mouse()
        api.nvim_win_set_option(code_win, 'winfixwidth', true) -- Fixed width
    else
        -- Si el buffer existe, simplemente lo volvemos a mostrar / if the buffer exists, just show it again
        vim.cmd('vsplit')
        vim.cmd('wincmd L')
        vim.cmd('vertical resize 50')
        code_win = api.nvim_get_current_win()
        api.nvim_win_set_buf(code_win, code_buf)
        enable_mouse()
        api.nvim_win_set_option(code_win, 'winfixwidth', true)
    end

    vim.cmd('startinsert')
end

-- ATAJOS CUSTOM / CUSTOM SHORTCUTS --
-- leader se cambia en lazy.lua
k.set('n', '<leader>ff', ':Telescope find_files<CR>', { desc = 'Buscar archivos con Telescope / Find file with Telescope', silent = true})
k.set('n', '<leader>fg', ':Telescope git_files<CR>', { desc = 'Buscar archivos de git con Telescope / Find git files with Telescope', silent = true})
k.set('n', '<leader>fb', ':Telescope file_browser<CR>', { desc = 'Abrir file browser de Telescope / Open Telescope file browser', silent = true})
k.set('n', '<leader>fn', ':Neotree toggle<CR>', { desc = 'Abrir/Cerrar Neotree / Open/Close Neotree', silent = true })
k.set('n', '<leader>l', ':Lazy<CR>', { desc = 'Abre LazyLim / Opens LazyVim', silent = true })
k.set('n', '<leader>qq', ':qa!<CR>', {desc = 'Cerrar sin guardar más fácil / Close easier without saving', silent = true })
k.set('n', '<leader>w', '<C-w>', {desc = "Cambiar ventanas / Change windows", silent = true })
k.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Enseñar errores del LSP / Show LSP errors", silent = true  })
k.set({'v','n'}, 'á', '"', { desc = "Cambia la combinacion para poner comillas con á / Changes the \" combination with á", silent = true }) -- Más fácil seleccionar buffers / Easier to select buffers
k.set('t', '<Esc>qt', [[<C-\><C-n><C-w>p<CR>]], { desc = "Sale del modo inserción en terminal y va al último buffer / Gets out of insert mode in terminal mode and goes to last buffer", silent = true })
k.set('n', '<leader>tw', toggle_terminal_window, { desc = "Abrir/Cerrar la terminal / Open/Close terminal", silent = true })
k.set('n', '<leader>tt', open_terminal, { desc = "Abrir/Cerrar la terminal / Open/Close terminal", silent = true })
k.set({'v', 'i'}, '<Up>', '<Nop>', { desc = "Impide usar las flechas / Blocks arrows" })
k.set({'v', 'i'}, '<Down>', '<Nop>', { desc = "Impide usar las flechas / Blocks arrows" })
k.set({'v', 'i'}, '<Left>', '<Nop>', { desc = "Impide usar las flechas / Blocks arrows" })
k.set({'v', 'i'}, '<Right>', '<Nop>', { desc = "Impide usar las flechas / Blocks arrows" })
k.set('n', '<Esc>', ':noh<CR>', { desc = "Esc me quita el highlight de búsqueda / Esc hides search highlight", silent = true })
k.set('n', '<leader>o', toggle_opencode_window, { desc = "Abrir opencode / Opens opencode", silent = true })
k.set('n', '<leader>m', ':MarkdownPreviewToggle<CR>', { desc = "Abrir/Cerrar previsualización de markdown / Open/Close markdown preview", silent = true })
k.set('n', '<C-a>', 'ggVG', { desc = "Seleccionar todo el texto / Select all text", silent = true })

-- ATAJOS DEBUGGER / DEBUGGER SHORTCUTS --
local dap = require("dap")
local dapui = require("dapui")
local dapvt = require("nvim-dap-virtual-text")

k.set("n", "<Left>", dap.toggle_breakpoint, { desc = "Toggle Breakpoint", noremap = true, silent = true })
k.set("n", "<leader>dc", dap.continue, { desc = "Continue", noremap = true, silent = true })
k.set("n", "<Up>", dap.step_into, { desc = "Step Into", noremap = true, silent = true })
k.set("n", "<Right>", dap.step_over, { desc = "Step Over", noremap = true, silent = true })
k.set("n", "<Down>", dap.step_out, { desc = "Step Out", noremap = true, silent = true })
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
