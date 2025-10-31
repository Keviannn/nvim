local o = vim.opt

-- OPCIONES DEL EDITOR / EDITOR OPTIONS --
o.number = true             -- Enseña el número de la línea / Shows line number
o.relativenumber = true     -- Muestra el número relativo a la línea actual / Numbers showed are relative to the actual line
o.clipboard = "unnamedplus" -- Usa el clipboard del sistema / Uses the OS clipboard
o.autoindent = true         -- Auto indenta para diferentes scopes / Autoindents based on the scope
o.expandtab = true          -- Pone al hacer tab el numero de espacios que configures / Set custom space number for tab
o.shiftwidth = 4            -- Para el autoindent 4 espacios / Autoindent uses 4 spaces
o.tabstop = 4               -- Para el tab normal 4 espacios / Tab uses 4 spaces
o.encoding = "UTF-8"        -- Encoding interno de nvim / Set nvim encoding
o.ruler = true              -- Muestra linea y columna en la barra de status / Show line and column in status bar
o.title = true              -- Cambia el nombre de la ventana al del file / Window name is the same as the opened file
o.hidden = true             -- Los buffers se esconden y no se pierden / Buffers does not dissapear they just hide
o.ttimeoutlen = 0           -- No espera a las combinaciones / Do not wait for combinations
o.wildmenu = true           -- Autocompletado de comandos con ventanita y todo / Autocomplete commands with window
o.showcmd = true            -- Te muestra lo que estas escribiendo en la linea de comandos de nvim / Shows what you are writing in command bar
o.showmatch = true          -- Muestra el par correspondiente de ({[]}) / Highlights the other ({[]})
o.inccommand = "split"      -- Muestra al hacer :s/../.. los cambios que se van a hacer / Preview :s command changes
o.splitbelow = true         -- Al splitear lo hace debajo / Splits below
o.mouse = ""                -- Desactiva el ratón en nvim / No mouse functions
o.linebreak = true          -- Los saltos en funcion de el tamaño de la ventana son en función de espacios y linebreak / Line jumps because of window size are because of spaces and linebreaks
