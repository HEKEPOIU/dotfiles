return {
    "neovim/nvim-lspconfig",
    dependencies = {
        { "williamboman/mason.nvim" },
        { "jay-babu/mason-nvim-dap.nvim" },
        { "williamboman/mason-lspconfig.nvim" },
        {
            "rcarriga/nvim-dap-ui",
            dependencies = {
                "mfussenegger/nvim-dap",
                "nvim-neotest/nvim-nio",
            },
        },
        {
            "stevearc/conform.nvim",
            opts = {}
        },
        {
            'saghen/blink.cmp',
            -- optional: provides snippets for the snippet source
            dependencies = { 'rafamadriz/friendly-snippets' },

            -- use a release tag to download pre-built binaries
            version = '1.6.0',

            ---@module 'blink.cmp'
            ---@type blink.cmp.Config
            opts = {
                -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
                -- 'super-tab' for mappings similar to vscode (tab to accept)
                -- 'enter' for enter to accept
                -- 'none' for no mappings
                --
                -- All presets have the following mappings:
                -- C-space: Open menu or open docs if already open
                -- C-n/C-p or Up/Down: Select next/previous item
                -- C-e: Hide menu
                -- C-k: Toggle signature help (if signature.enabled = true)
                --
                -- See :h blink-cmp-config-keymap for defining your own keymap
                keymap = {

                    ['<Tab>'] = {
                        function(cmp)
                            if cmp.snippet_active() then
                                return cmp.snippet_forward()
                            else
                                return cmp.select_next()
                            end
                        end,
                        'fallback'
                    },
                    ['<S-Tab>'] = {
                        function(cmp)
                            if cmp.snippet_active() then
                                return cmp.snippet_backward()
                            else
                                return cmp.select_prev()
                            end
                        end,
                        'fallback'
                    },
                    ['<CR>'] = {
                        "accept",
                        "fallback"
                    },
                    ['<C-f>'] = { "fallback" }


                },
                cmdline = {
                    keymap = {
                        preset = 'cmdline',

                        ['<CR>'] = {
                            "fallback"
                        },
                        ['<Tab>'] = {
                            "insert_next",
                            "fallback"
                        },
                        ['<S-Tab>'] = {
                            "insert_prev",
                            "fallback"
                        }
                    },
                    completion = {
                        menu = { auto_show = true },
                        list = {
                            selection = {
                                preselect = false, auto_insert = false,
                            }
                        }
                    },
                },

                appearance = {
                    -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                    -- Adjusts spacing to ensure icons are aligned
                    nerd_font_variant = 'mono'
                },

                -- (Default) Only show the documentation popup when manually triggered
                completion = {
                    documentation = { auto_show = true, auto_show_delay_ms = 50, },
                    menu = {
                        draw = {
                            columns = { { "label", }, { "kind_icon", "source_name", gap = 1 } },

                        }
                    },
                    list = {
                        selection = {
                            preselect = true, auto_insert = false,
                        }
                    }

                },
                signature = {
                    enabled = true,
                    window = {
                        border = "rounded",
                    }
                },

                -- Default list of enabled providers defined so that you can extend it
                -- elsewhere in your config, without redefining it, due to `opts_extend`
                --

                sources = {
                    default = function(ctx)
                        local success, node = pcall(vim.treesitter.get_node)
                        if success and node and vim.tbl_contains({ 'comment', 'line_comment', 'block_comment' }, node:type()) then
                            return { 'buffer' }
                        else
                            return { 'lsp', 'path', 'snippets', 'buffer' }
                        end
                    end,
                },
                fuzzy = {
                    sorts = {
                        'exact',

                        'score', -- Primary sort: by fuzzy matching score
                        function(a, b)
                            local source_priority = {
                                snippets = 4,
                                lsp = 3,
                                buffer = 2,
                                path = 1,
                            }
                            local sa = source_priority[a.source_id]
                            local sb = source_priority[b.source_id]
                            if sa == nil or sb == nil then
                                return false
                            end
                            return sa > sb
                        end,
                        --
                        -- 'sort_text', -- Secondary sort: by sortText field if scores are equal
                        -- 'kind',
                    }
                },
                snippets = { preset = 'luasnip' },

            },
            opts_extend = { "sources.default" }

        },
        { "L3MON4D3/LuaSnip" },
        {
            "kevinhwang91/nvim-ufo",
            dependencies = { "kevinhwang91/promise-async" },
        },
        {
            "pmizio/typescript-tools.nvim",
            dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        },
        {
            "ray-x/lsp_signature.nvim",
        }
    },
    config = function()
        --#region JS/TS Setup. ---------------------------------------------



        require("typescript-tools").setup {
            filetypes = {
                "javascript",
                "javascriptreact",
                "javascript.jsx",
                "typescript",
                "typescriptreact",
                "typescript.tsx",
                "vue",
            },
            settings = {
                tsserver_plugins = {
                    "@vue/typescript-plugin",
                },
            },
        }
        --#endregion JS/TS Setup. ---------------------------------------------




        --#region common Lsp shortcut.
        require("conform").formatters.odinfmt = {
            inherit = false,
            command = "odinfmt",
            args = { "-stdin" },
            stdin = function()
                local file_contents = vim.fn.readfile(vim.fn.expand('%'))
                return table.concat(file_contents, "\n")
            end,
        }
        require("conform").setup({
            formatters_by_ft = {
                lua = { lsp_format = "fallback" },
                cpp = { "custom_clang_format" },
                javascript = { "prettier", stop_after_first = true },
                typescript = { "prettier", stop_after_first = true },
                typescriptreact = { "prettier", stop_after_first = true },
                javascriptreact = { "prettier", stop_after_first = true },
                odin = { "odinfmt" },
                just = { "just" },
                typst = { "typstfmt" },
                glsl = { "custom_clang_format"}
            },
            formatters = {
                custom_clang_format = {
                    command = "clang-format",
                    args = {
                        "--fallback-style=LLVM",
                    }
                },
            },
            default_format_opts = {
                lsp_format = "fallback",
            },
        })


        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('user_lsp_attach', { clear = true }),
            callback = function(event)
                vim.keymap.set('n', 'K', function()
                        vim.lsp.buf.hover(
                            {
                                border = "rounded",
                            }
                        )
                    end,
                    { desc = "Show hover information", buffer = event.buf })
                vim.keymap.set('n', '<leader>vws', function() vim.lsp.buf.workspace_symbol() end,
                    { desc = "List workspace symbols", buffer = event.buf })
                vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1, float = true }) end,
                    { desc = "Go to next diagnostic", buffer = event.buf })
                vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1, float = true }) end,
                    { desc = "Go to previous diagnostic", buffer = event.buf })
                vim.keymap.set('n', '<M-CR>', function() vim.lsp.buf.code_action() end,
                    { desc = "Show code actions", buffer = event.buf })
                vim.keymap.set('n', '<leader>vrr', function() vim.lsp.buf.references() end,
                    { desc = "Find references", buffer = event.buf })
                vim.keymap.set('n', '<leader>vrn', function() vim.lsp.buf.rename() end,
                    { desc = "Rename symbol", buffer = event.buf })
                vim.keymap.set('i', '<C-h>', function() vim.lsp.buf.signature_help() end,
                    { desc = "Show signature help", buffer = event.buf })
                vim.keymap.set("n", "<space>eE", vim.diagnostic.open_float,
                    { desc = "Show error on cursor", buffer = event.buf })
                vim.keymap.set({ 'n' }, '<Leader>K', function()
                    vim.lsp.buf.signature_help()
                end, { silent = true, noremap = true, desc = 'toggle signature' })
                vim.keymap.set("n", "<leader>f", require("conform").format, { desc = "Format buffer" })
            end,
        })
        --#endregion

        vim.o.foldcolumn = '1' -- '0' is not bad
        vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true

        -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
        vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
        vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

        require('mason').setup {
            registries = {
                "github:mason-org/mason-registry",
            },
        }

        local function get_clangd_cmd()
            local project_path = vim.fn.getcwd() -- Get the current project directory

            -- Define the paths for Mason and Xcode clangd
            local mason_clangd = "clangd"
            local xcode_clangd = "/usr/bin/clangd"

            -- Define project-specific rules
            if string.match(project_path, ".*XcodeProject.*") then
                return xcode_clangd
            else
                return mason_clangd
            end
        end

        require("mason-lspconfig").setup({
            ensure_installed = { "clangd", "bashls", "neocmake", "lua_ls", "marksman" },
            automatic_enable = {
                exclude = { "ts_ls" }
            }
        })
        vim.lsp.config.bashls = {
            filetypes = { "sh", "bash", "zsh" },
        }
        vim.lsp.config.lua_ls = {
            on_init = function(client)
                if client.workspace_folders then
                    local path = client.workspace_folders[1].name
                    if path ~= vim.fn.stdpath('config') and (vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc')) then
                        return
                    end
                end

                client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                    runtime = {
                        version = 'LuaJIT'
                    },
                    workspace = {
                        checkThirdParty = false,
                        library = {
                            vim.env.VIMRUNTIME
                        }
                    }
                })
            end,
            settings = {
                Lua = {}
            }
        }
        vim.lsp.config.zls = {
            cmd = {
                "zls",
                "--config-path",
                vim.fn.stdpath('config') .. "/lsp_config/zls.json",
            }
        }

        vim.lsp.config.clangd = {
            capabilities = require('blink.cmp').get_lsp_capabilities({
                offsetEncoding = { "utf-16" },
            }),
            cmd = {
                get_clangd_cmd(),
                "--background-index",
                "--header-insertion-decorators",
                "--header-insertion=never",
                "--background-index-priority=normal",
                "--enable-config",
                "--clang-tidy",
            },
        }
        root = ""
        vim.lsp.config.ols = {
            root_dir = function(bufnr, on_dir)
                local fname = vim.api.nvim_buf_get_name(bufnr)
                if root == "" then
                    root = require('lspconfig.util').root_pattern('ols.json', '.git')(fname)
                end
                on_dir(root)
            end,
        }

        -- require('lspconfig').gdscript.setup(lsp_capabilities)


        require('ufo').setup()
        --#endregion


        --#region dap
        require("mason-nvim-dap").setup({
            ensure_installed = { "codelldb" },
            handlers = {
                function(config)
                    -- all sources with no handler get passed here

                    -- Keep original functionality
                    require('mason-nvim-dap').default_setup(config)
                end,
                codelldb = function(config)
                    config.configurations = {};
                    -- In Some how, apple codelldb will auto add some breakpoint,
                    -- not sure it came form apple codelldb or something
                    require("dap").defaults.codelldb.exception_breakpoints = {}

                    require('mason-nvim-dap').default_setup(config)
                end
            }
        })

        local dap, dapui = require("dap"), require("dapui")

        dapui.setup()


        dap.adapters.godot = {
            type = "server",
            host = '127.0.0.1',
            port = 6006,
        }

        dap.configurations.gdscript = {
            {
                type = "godot",
                request = "launch",
                name = "Launch scene",
                project = "${workspaceFolder}",
                launch_scene = true,
            },
        }

        vim.api.nvim_set_keymap('n', '<F5>', '<Cmd>lua require"dap".continue()<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<F9>', '<Cmd>lua require"dap".toggle_breakpoint()<CR>',
            { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<F10>', '<Cmd>lua require"dap".step_over()<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<F11>', '<Cmd>lua require"dap".step_into()<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<S-F11>', '<Cmd>lua require"dap".step_out()<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<S-F5>', '<Cmd>lua require"dap".terminate()<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<Leader>tf', '<Cmd>lua require("dapui").float_element() <CR>',
            { noremap = true, silent = true })

        vim.api.nvim_set_keymap('n', '<Leader>tt', '<Cmd>lua require("dapui").toggle() <CR>',
            { noremap = true, silent = true })


        require("overseer").enable_dap()
        --#endregion

        --#region Show error on hold.
        local ns = vim.api.nvim_create_namespace("my_diagnostics_ns")

        vim.diagnostic.config({
            virtual_text = false,
            underline = true,
        })

        vim.api.nvim_create_autocmd("CursorHold", {
            callback = function()
                local bufnr = vim.api.nvim_get_current_buf()
                local cursor = vim.api.nvim_win_get_cursor(0)
                local lnum = cursor[1] - 1
                local diagnostics = vim.diagnostic.get(bufnr, { lnum = lnum })


                if #diagnostics > 0 then
                    vim.diagnostic.show(ns, bufnr, diagnostics, {
                        virtual_text = true,
                    })
                end
            end,
        })

        vim.api.nvim_create_autocmd("CursorMoved", {
            callback = function()
                vim.diagnostic.hide(ns)
                vim.diagnostic.config({
                    virtual_text = false,
                    underline = true,
                })
            end,
        })
        --#endregion Show error on hold.


        --#region luasnip setup
        require('luasnip.loaders.from_vscode').lazy_load({ paths = vim.fn.stdpath('config') .. '/lsp_config/snippets' })
        require('luasnip.loaders.from_snipmate').lazy_load({ paths = vim.fn.stdpath('config') .. '/lsp_config/snippets' })
    end
}
