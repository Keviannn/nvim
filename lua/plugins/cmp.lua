return {
    {
        "hrsh7th/nvim-cmp",
        version = false, -- last release is way too old
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            {
                "L3MON4D3/LuaSnip",
                version = "v2.*",
                build = "make install_jsregexp"
            },
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
            "onsails/lspkind.nvim",
            "uga-rosa/cmp-dictionary",
        },

        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local lspkind = require("lspkind")
            local dict = require("cmp_dictionary")
            require("luasnip.loaders.from_vscode").lazy_load()

            -- Source custom con diccionario español
            dict.setup({
                paths = {vim.fn.expand("~/.config/nvim/lua/kevia/dictionaries/dic_es.txt")},
            })

            cmp.setup({

                completion = {
                    completeopt = "menu,menuone,preview,noselect",
                },

                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },

                mapping = cmp.mapping.preset.insert({
                    ["<C-k>"] = cmp.mapping.select_prev_item(),
                    ["<C-j>"] = cmp.mapping.select_next_item(),
                    ["<CR>"] = cmp.mapping.confirm({ select = false }),

                    -- Salto hacia el siguiente placeholder (no se como va)
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    }),

                sources = cmp.config.sources({
                    { name = "nvim_lsp"},
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" },
                }),

                formatting = {
                    format = function(entry, vim_item)

                        -- Se llama a la funcion cmp_format con (entry, vim_item) y configurada con maxwidth y ellipsis_char 
                        -- y te devuelve vim_item en funcion de eso
                        vim_item = require("lspkind").cmp_format({
                            maxwidth = 50,
                            ellipsis_char = "...",
                        })(entry, vim_item)

                        -- Custom: Icono, texto y color para diccionario
                        if entry.source.name == "dictionary" then
                            vim_item.kind = " Dictionary"
                            vim_item.kind_hl_group = "CmpItemKindVariable"
                        end

                        return vim_item
                    end,
                }
            })

            -- Custom: Para archivos txt usa el diccionario si no, no
            cmp.setup.filetype("text", {
                sources = cmp.config.sources({
                    { name = "dictionary", keyword_length = 2 },
                    { name = "buffer" },
                    { name = "path" },
                }),
            })

        end,
    },
}
