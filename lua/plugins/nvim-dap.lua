return
{
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    dependencies = {
        "rcarriga/nvim-dap-ui", -- Opcional: Da una UI mejor, se puede configurar
        "nvim-neotest/nvim-nio", -- Requerido
        "jay-babu/mason-nvim-dap.nvim", -- Instalar debuggers con mason
        "theHamsta/nvim-dap-virtual-text", -- Permite ver valores en el código durante el debug
    },

    config = function()
        local mason_dap = require("mason-nvim-dap")
        local dap = require("dap")
        local ui = require("dapui")
        local dap_virtual_text = require("nvim-dap-virtual-text")

        dap_virtual_text.setup() -- Inicializa sin configuraciones custon

        mason_dap.setup({
            ensure_installed = { "cppdbg" },
            automatic_installation = true,
            handlers = {
                function (config)
                    require("mason-nvim-dap").default_setup(config)
                end,
            }
        })

        dap.configurations = {
            c = {
                {
                    name = "Launch file",
                    type = "cppdbg",
                    request = "launch",
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    end,
                    args = function ()
                        local input = vim.fn.input("Args: ")
                        return vim.fn.split(input, " ", true)
                    end,
                    cwd = "${workspaceFolder}",
                    stopAtEntry = false,
                    MIMode = "gdb",
                    setupCommands = {
                        {
                            text = "-enable-pretty-printing",
                            description = "Enable GDB pretty printing",
                            ignoreFailures = true,
                        },
                    },
                },
                {
                    name = "Attach to gdbserver :1234",
                    type = "cppdbg",
                    request = "launch",
                    MIMode = "gdb",
                    miDebuggerServerAddress = "localhost:1234",
                    miDebuggerPath = "/usr/bin/gdb",
                    cwd = "${workspaceFolder}",
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    end,
                },
            },
        }

        dap.configurations.cpp = dap.configurations.c

        ui.setup({
            layouts = { {

                -- Panel izquierdo
                elements = {
                    { id = "scopes", size = 0.40 },
                    { id = "breakpoints", size = 0.30 },
                    { id = "stacks", size = 0.30 },
                    --{ id = "watches", size = 0.20}, -- No uso watches de momento
                },
                size = 40,
                position = "left", },

                -- Panel derecho
                {
                    elements = {
                        --{ id = "repl", size = 0.6 }, -- No uso REPL de momento
                        { id = "console", size = 1 },
                    },
                    size = 12,
                    position = "bottom",
                },
            },
        })

        vim.fn.sign_define("DapBreakpoint", { text = "🪦" })

        dap.listeners.before.attach.dapui_config = function()
            ui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            ui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            ui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            ui.close()
        end

    end,
}


