return {
    "neovim/nvim-lspconfig",
    dependencies = {
        {
            "williamboman/mason.nvim",
            config = false
        },
        {
            "williamboman/mason-lspconfig.nvim",
            config = false
        },
        {
            "stevearc/conform.nvim",
            config = false
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
                            return { "lazydev", 'lsp', 'path', 'snippets', 'buffer' }
                        end
                    end,
                    providers = {
                        lazydev = {
                            name = "LazyDev",
                            module = "lazydev.integrations.blink",
                            -- make lazydev completions top priority (see `:h blink.cmp`)
                            score_offset = 100,
                        },
                    },
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
            config = false
        },
        {
            "folke/lazydev.nvim",
            ft = "lua", -- only load on lua files
            opts = {
                library = {
                    -- See the configuration section for more details
                    -- Load luvit types when the `vim.uv` word is found
                    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                },
            },
        },
    },
    config = function()
        --#region common Lsp shortcut.
        require("conform").setup({
            formatters_by_ft = {
                lua = { lsp_format = "fallback" },
                cpp = { "custom_clang_format" },
                odin = { "odinfmt" },
                glsl = { "custom_clang_format" }
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
                vim.keymap.set("n", "<space>eE", vim.diagnostic.open_float,
                    { desc = "Show error on cursor", buffer = event.buf })
                vim.keymap.set("n", "<leader>f", require("conform").format, { desc = "Format buffer" })
            end,
        })
        --#endregion

        vim.o.foldcolumn = '1' -- '0' is not bad
        vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true

        require('mason').setup {
            registries = {
                "github:mason-org/mason-registry",
                "github:Crashdummyy/mason-registry",
            },
        }


        local ensure_list = { "marksman", "typos_lsp", "harper_ls", "jsonls" }

        local optional_modules = { "godot", "odin", "cpp", "bash", "ts" }

        for _, mod in ipairs(optional_modules) do
            ---@class LanguageModule
            local module = require("plugins.optional_config." .. mod)
            if module.enable == true then
                vim.list_extend(ensure_list, module.ensure_installed)
                module.setup()
            end
        end

        require("mason-lspconfig").setup({
            ensure_installed = ensure_list,
            automatic_enable = {
                exclude = { "ts_ls" }
            }
        })
        vim.lsp.config.harper_ls = {
            linters = {
                SentenceCapitalization = false,
                SpellCheck = false
            }
        }



        vim.lsp.enable({ "nushell" })
        require('ufo').setup()



        require('luasnip.loaders.from_vscode').lazy_load({ paths = vim.fn.stdpath('config') .. '/lsp_config/snippets' })
        require('luasnip.loaders.from_snipmate').lazy_load({ paths = vim.fn.stdpath('config') .. '/lsp_config/snippets' })
    end
}
