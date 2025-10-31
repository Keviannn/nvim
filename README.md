# My Custom NeoVim Setup

A personalized neovim configuration that fuses **lazyvim** and custom configurations, keybindsand functions for an optimized and efficient coding environment.

Comments inside files are available in spanish and english.

---

## Description

I have been interested in neovim for quite some time, and during the first semester of 2025, i fully committed to creating a setup that suits my needs.  
this configuration primarily uses the **lazyvim** plugin manager, and whenever existing plugins weren't enough, i implemented my own lua functions to fill in the gaps.

---

## Plugins

This setup includes a variety of plugins configured to enhance productivity:

- **autopairs**: automatically closes brackets, braces, and parentheses.
- **gruvbox-material**: handles the editor's color scheme.
- **harpoon**: efficiently manages open buffers for quick navigation.
- **indent-blankline**: visualizes indentation with a custom character.
- **mason, mason-lspconfig, nvim-lspconfig**: install and integrate lsps for various languages.
- **nvim-dap**: provides a visual debugging environment for multiple languages.
- **telescope**: file search with live preview.
- **treesitter**: syntax parsing and highlighting.
- **cpm**: autocompletion engine supporting dictionaries, snippets, and lsps.
- **lualine**: modern, customizable status line replacing the default one.

All plugins and related keybinds have been configured to fit my workflow and are present and explained in [init.lua](./init.lua).

---

## Custom functions

Two main lua functions have been implemented:

### toggle_terminal

This function toggles a horizontal terminal window and buffer for getting in an out fast and easy.

``` lua
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
```

### open_naviterm

This function does almost the same as toggle_terminal but is an integration with [naviterm](https://gitlab.com/detoxify92/naviterm).

``` lua
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
```

## Additional features
- A custom Spanish dictionary for autocompletion, generated from the **20,000 most frequent words from the RAE corpus** using a custom C program handling UTF-8 characters.

- CMP configuration shows a book icon and "Dictionary" label for dictionary suggestions, improving visual distinction between LSP and text completions.

## Screenshot

Example of real working with this setup for my HPC class in university.

![nvim hpc](./example.png)

