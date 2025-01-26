return {
    "neovim/nvim-lspconfig",
    enabled = not vim.g.vscode,
    dependencies = {
        { "williamboman/mason.nvim" },
        { "jay-babu/mason-null-ls.nvim" },
        { "L3MON4D3/LuaSnip" },
        { "hrsh7th/nvim-cmp" },
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-path" },
        {
            "kevinhwang91/nvim-ufo",
            dependencies = { "kevinhwang91/promise-async" },
        },
        {
            'saadparwaiz1/cmp_luasnip'
        },
        { "williamboman/mason-lspconfig.nvim" },
        { "onsails/lspkind.nvim" },
        {
            "pmizio/typescript-tools.nvim",
            dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        },
        {
            "rafamadriz/friendly-snippets",
        },
        {
            "ray-x/lsp_signature.nvim",
        },
        {
            "nvimtools/none-ls.nvim",
            dependencies = {
                "nvim-lua/plenary.nvim",
                {
                    "ThePrimeagen/refactoring.nvim",
                    dependencies = {
                        "nvim-lua/plenary.nvim",
                        "nvim-treesitter/nvim-treesitter",
                    },
                    config = function()
                        require("refactoring").setup(
                            {
                                -- prompt for return type
                                prompt_func_return_type = {
                                    go = true,
                                    cpp = true,
                                    c = true,
                                    java = true,
                                },
                                -- prompt for function parameters
                                prompt_func_param_type = {
                                    go = true,
                                    cpp = true,
                                    c = true,
                                    java = true,
                                },
                            }
                        )
                    end,
                },
            },
        },
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
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('user_lsp_attach', { clear = true }),
            callback = function(event)
                local opts = { buffer = event.buf }

                vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end,
                    { desc = "Show hover information", unpack(opts) })
                vim.keymap.set('n', '<leader>vws', function() vim.lsp.buf.workspace_symbol() end,
                    { desc = "List workspace symbols", unpack(opts) })
                vim.keymap.set('n', ']d', function() vim.diagnostic.goto_next() end,
                    { desc = "Go to next diagnostic", unpack(opts) })
                vim.keymap.set('n', '[d', function() vim.diagnostic.goto_prev() end,
                    { desc = "Go to previous diagnostic", unpack(opts) })
                vim.keymap.set('n', '<M-CR>', function() vim.lsp.buf.code_action() end,
                    { desc = "Show code actions", unpack(opts) })
                vim.keymap.set('n', '<leader>vrr', function() vim.lsp.buf.references() end,
                    { desc = "Find references", unpack(opts) })
                vim.keymap.set('n', '<leader>vrn', function() vim.lsp.buf.rename() end,
                    { desc = "Rename symbol", unpack(opts) })
                vim.keymap.set('i', '<C-h>', function() vim.lsp.buf.signature_help() end,
                    { desc = "Show signature help", unpack(opts) })
                vim.keymap.set("n", "<space>eE", vim.diagnostic.open_float,
                    { desc = "Show error on cursor", unpack(opts) })
                vim.keymap.set({ 'n' }, '<Leader>K', function()
                    vim.lsp.buf.signature_help()
                end, { silent = true, noremap = true, desc = 'toggle signature' })
            end,
        })
        --#endregion


        --#region Lsp signature popup on typing arg.
        local signature = require("lsp_signature")
        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
                local bufnr = args.buf
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if vim.tbl_contains({ 'null-ls' }, client.name) then -- blacklist lsp
                    return
                end
                signature.on_attach({
                    bind = true, -- This is mandatory, otherwise border config won't get registered.
                    max_height = 3,
                    handler_opts = {
                        border = "rounded"
                    },
                    floating_window_off_x = 5,                           -- adjust float windows x position.
                    floating_window_off_y = function()                   -- adjust float windows y position.
                        -- e.g. Set to -2 can make floating window move up 2 lines
                        local linenr = vim.api.nvim_win_get_cursor(0)[1] -- buffer line number
                        local pumheight = vim.o.pumheight
                        local winline = vim.fn.winline()                 -- line number in the window
                        local winheight = vim.fn.winheight(0)

                        -- window top
                        if winline - 1 < pumheight then
                            return pumheight
                        end

                        -- window bottom
                        if winheight - winline < pumheight then
                            return -pumheight
                        end
                        return 0
                    end,
                }, bufnr)
            end,
        })
        --#endregion

        --#region Lsp server setup and fold provider setup.
        local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

        lsp_capabilities.textDocument.foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true
        }
        -- ufo Config use to fold code.

        vim.o.foldcolumn = '1' -- '0' is not bad
        vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true

        -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
        vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
        vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

        require('mason').setup()
        require("mason-lspconfig").setup_handlers {
            function(server_name)
                if server_name == "tsserver" then
                    return
                end
                require('lspconfig')[server_name].setup({
                    capabilities = lsp_capabilities,
                })
            end,
            ["clangd"] = function()
                local clangd_cap = lsp_capabilities
                clangd_cap.offsetEncoding = { "utf-16" }
                require("lspconfig")["clangd"].setup {
                    capabilities = clangd_cap,
                    cmd = {
                        "clangd",
                        "--background-index",
                        "--header-insertion-decorators",
                        "--fallback-style=Google",
                        "--header-insertion=never",
                        "--function-arg-placeholders=false",
                        "--clang-tidy",
                    },
                }
            end,
            ['bashls'] = function ()
                require('lspconfig').bashls.setup({
                    capabilities = lsp_capabilities,
                    filetypes = { "bash", "sh", "just" }
                })
            end
        }

        -- temp Solve for rust update interrupted typing.
        -- https://github.com/neovim/neovim/issues/30985
        for _, method in ipairs({ 'textDocument/diagnostic', 'workspace/diagnostic' }) do
            local default_diagnostic_handler = vim.lsp.handlers[method]
            vim.lsp.handlers[method] = function(err, result, context, config)
                if err ~= nil and err.code == -32802 then
                    return
                end
                return default_diagnostic_handler(err, result, context, config)
            end
        end
        require('lspconfig').gdscript.setup(lsp_capabilities)


        require('ufo').setup()
        --#endregion

        --#region null_ls setup.
        local null_ls = require("null-ls")

        require("mason-null-ls").setup({
            ensure_installed = {
                "clang-format",
                "typstfmt",
            },
            automatic_installation = true,
            handlers = {

            },
        })

        null_ls.setup {
            sources = {
                null_ls.builtins.code_actions.gitsigns,
                null_ls.builtins.code_actions.refactoring.with({
                    filetypes = {
                        "go",
                        "javascript",
                        "lua",
                        "python",
                        "typescript",
                        "cpp",
                        "cs",
                        "csharp"
                    }
                }),
                null_ls.builtins.formatting.prettierd.with({
                    filetypes = {
                        "javascript",
                        "typescript",
                        "javascriptreact",
                        "typescriptreact",
                        "css",
                        "scss",
                        "html",
                        "json",
                        "yaml",
                        "markdown",
                        "graphql",
                        "md",
                        "txt",
                    },
                    only_local = "node_modules/.bin",
                }),
            },
            -- debug = true,
        }

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

        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
            border = "rounded", -- 可選值：'none', 'single', 'double', 'rounded', 'solid', 'shadow'
        })

        --#region luasnip setup
        require('luasnip.loaders.from_vscode').lazy_load()
        local lspkind = require('lspkind')
        local cmp = require('cmp')
        local cmp_select = { behavior = cmp.SelectBehavior.Select }
        cmp.setup({
            sources = {
                { name = 'nvim_lsp' },
                { name = 'luasnip', keyword_length = 2 },
                { name = 'path' },
                { name = 'buffer',  keyword_length = 3 },
            },
            mapping = cmp.mapping.preset.insert({
                ['<S-Tab>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<Tab>'] = cmp.mapping.select_next_item(cmp_select),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
            }),
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },
            formatting = {
                fields = {  "abbr","kind", "menu" },
                format = function(entry, vim_item)
                    local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
                    local strings = vim.split(kind.kind, "%s", { trimempty = true })
                    kind.kind = " " .. (strings[1] or "") .. " "
                    kind.menu = "    " .. (strings[2] or "")

                    return kind
                end,
            },
        })

        --#endregion
    end
}
