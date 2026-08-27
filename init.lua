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
        vim.b.display_name = "Term"
        vim.b.command = "bash" 
        vim.b.buffer_icon = ""
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
    vim.b.display_name = "Term"
    vim.b.command = "bash" 
    vim.b.buffer_icon = ""
end

local mouse_augroup = api.nvim_create_augroup("TerminalMouse", { clear = true })
api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
    group = mouse_augroup,
    callback = function()
        if vim.bo.buftype == "terminal" then
            vim.opt.mouse = "a"
        else
            vim.opt.mouse = ""
        end
    end
})

local function open_something()
    local cmd = vim.fn.input("Select your program: ")
    if cmd == "" then
        vim.print("")
        return
    end

    vim.cmd('terminal ' ..  cmd)
    vim.cmd('startinsert')
    local in_buf = api.nvim_get_current_buf()

    local parts = vim.split(cmd, " ")
    local title
    if #parts > 1 then
        title = parts[2]:sub(1,1):upper() .. parts[2]:sub(2)
    else
        title = parts[1]:sub(1,1):upper() .. parts[1]:sub(2)
    end
    vim.b.display_name = title
    vim.b.command = parts[1]
    vim.opt.mouse = "a"
end

-- ATAJOS CUSTOM / CUSTOM SHORTCUTS --

-- Finder
k.set('n', '<leader>ff', ':FzfLua files<CR>', { desc = 'Buscar archivos con FzfLua / Find file with FzfLua', silent = true})
k.set('n', '<leader>fg', ':FzfLua git_files<CR>', { desc = 'Buscar archivos de git con FzfLua / Find git files with FzfLua', silent = true})
k.set('n', '<leader>fb', ':FzfLua buffers<CR>', { desc = '', silent = true})
k.set('n', '<leader>fr', ':FzfLua grep<CR>', { desc = 'Buscar archivos por su texto/ Find files by text', silent = true})
k.set('n', '<leader>fw', ':FzfLua grep_cword<CR>', { desc = '', silent = true})
k.set({'n', 'v'}, '<leader>fv', ':FzfLua grep_visual<CR>', { desc = '', silent = true})

-- Markdown
vim.keymap.set("n", "<leader>md", ":MarkdownPreview<CR>", { desc = "Markdown: Start preview" })

-- Other plugins
k.set('n', '<leader>fn', ':Neotree toggle<CR>', { desc = 'Abrir/Cerrar Neotree / Open/Close Neotree', silent = true })
k.set('n', '<leader>l', ':Lazy<CR>', { desc = 'Abre LazyLim / Opens LazyVim', silent = true })

-- Terminal related
k.set('n', '<leader>tw', toggle_terminal_window, { desc = "Abrir/Cerrar la terminal / Open/Close terminal", silent = true })
k.set('n', '<leader>tt', open_terminal, { desc = "Abrir/Cerrar la terminal / Open/Close terminal", silent = true })
k.set('n', '<leader>nt', function()
    vim.cmd('terminal')
    vim.cmd('startinsert')
    buf = api.nvim_get_current_buf()
    vim.b.command = "bash"
    vim.b.display_name = "Bash"
end, { desc = "Abrir una nueva terminal / Open a new terminal", silent = true })
k.set('t', '<Esc>qt', [[<C-\><C-n><C-w>p<CR>]], { desc = "Sale del modo inserción en terminal y va al último buffer / Gets out of insert mode in terminal mode and goes to last buffer", silent = true })
k.set('t', '<Esc><Esc>', [[<C-\><C-n>]], { desc = "Sale del modo inserción en terminal / Gets out of insert mode in terminal", silent = true})
k.set('t', '<Esc>lt', function()
    vim.cmd('stopinsert')
    toggle_terminal_window()
end, { desc = "Sale de la terminal / Gets out of the terminal", silent = true})
k.set('n', '<leader>r', open_something, { desc = "Abrir algo / Opens something", silent = true })


-- Control related
k.set({'v', 'i'}, '<Up>', '<Nop>', { desc = "Impide usar las flechas / Blocks arrows" })
k.set({'v', 'i'}, '<Down>', '<Nop>', { desc = "Impide usar las flechas / Blocks arrows" })
k.set({'v', 'i'}, '<Left>', '<Nop>', { desc = "Impide usar las flechas / Blocks arrows" })
k.set({'v', 'i'}, '<Right>', '<Nop>', { desc = "Impide usar las flechas / Blocks arrows" })
k.set('n', '<Esc>', ':noh<CR>', { desc = "Esc me quita el highlight de búsqueda / Esc hides search highlight", silent = true })
k.set('n', '<C-a>', 'ggVG', { desc = "Seleccionar todo el texto / Select all text", silent = true })
k.set('n', '<leader>qq', ':qa!<CR>', {desc = 'Cerrar sin guardar más fácil / Close easier without saving', silent = true })
k.set('n', '<leader>w', '<C-w>', {desc = "Cambiar ventanas / Change windows", silent = true })
k.set({'v','n'}, 'á', '"', { desc = "Cambia la combinacion para poner comillas con á / Changes the \" combination with á", silent = true }) -- Más fácil seleccionar registros / Easier to select registers

k.set('n', '<leader><Tab>', ':tabnew<CR>', {desc = "", silent = true })
k.set('n', '<Tab>', ':tabnext<CR>', {desc = "", silent = true })
k.set('n', '<S-Tab>', ':tabprev<CR>', {desc = "", silent = true })
k.set('n', '<A-h>', ':bprev<CR>', {desc = "", silent = true })
k.set('n', '<A-l>', ':bnext<CR>', {desc = "", silent = true })

-- LSP related
k.set('n', '<leader>le', vim.diagnostic.open_float, { desc = "Enseñar errores del LSP / Show LSP errors", silent = true  })
k.set('n', '<leader>ld', vim.lsp.buf.definition, { })
k.set('n', '<leader>li', vim.lsp.buf.implementation, { })
k.set('n', '<leader>ls', vim.lsp.buf.hover, { })
k.set('n', '<leader>lr', vim.lsp.buf.references, { })

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
end, { desc = "Terminate", noremap = true, silent = true })

k.set("n", "<leader>de", function()
  dap.set_exception_breakpoints({ "all" })
end, { desc = "Set Exception Breakpoints", noremap = true, silent = true })

-- CAMBIAR COMO SE VEN LOS COMENTARIOS TODO / CHANGES HOW TODO COMMENTS LOOK --
api.nvim_set_hl(0, "Todo", {fg = "#7fbfff", bg = "NONE", italic = true})
