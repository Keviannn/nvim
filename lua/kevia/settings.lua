local o = vim.opt

-- OPCIONES DEL EDITOR --
o.number = true             -- Enseña el número de la línea
o.relativenumber = true     -- Muestra el número relativo
o.clipboard = "unnamedplus" -- Usa el clipboard del sistema
o.autoindent = true         -- Auto indenta para diferentes scopes
o.expandtab = true          -- Pone al hacer tab el numero de espacios que configures
o.shiftwidth = 4            -- Para el autoindent 4 espacios
o.tabstop = 4               -- Para el tab normal 4 espacios
o.encoding = "UTF-8"        -- Encoding interno de nvim
o.ruler = true              -- Muestra linea y columna
o.title = true              -- Cambia el nombre de la ventana al del file
o.hidden = true             -- Los buffers se esconden y no se pierden
o.ttimeoutlen = 0           -- No espera a las combinaciones
o.wildmenu = true           -- Autocompletado de comandos con ventanita y todo
o.showcmd = true            -- Te muestra lo que estas escribiendo en la linea de comandos de nvim
o.showmatch = true          -- Muestra el par correspondiente de ({[]})
o.inccommand = "split"      -- Muestra al hacer :s/../.. los cambios que se van a hacer
o.splitbelow = true         -- Al splitear lo hace debajo
o.mouse = ""                -- Desactiva el ratón en nvim
o.linebreak = true          -- Los saltos en funcion de el tamaño de la ventana son en función de espacios y linebreak
