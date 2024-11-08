return {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    enabled = not vim.g.vscode,
    dependencies = {
        { "williamboman/mason.nvim" },
        { "neovim/nvim-lspconfig" },
        { "hrsh7th/nvim-cmp" },
        { "hrsh7th/cmp-nvim-lsp" },
        { "jay-babu/mason-null-ls.nvim" },
        { "L3MON4D3/LuaSnip" },
        { "williamboman/mason-lspconfig.nvim" },
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-path" },
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
            event = "VeryLazy",
            opts = {},
            config = function(_, opts) require 'lsp_signature'.setup(opts) end
        },
        {
            'saadparwaiz1/cmp_luasnip'
        },
    },
    config = function()
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

        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('user_lsp_attach', { clear = true }),
            callback = function(event)
                local opts = { buffer = event.buf }

                vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end,
                    { desc = "Go to definition", unpack(opts) })
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
            end,
        })

        local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

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
        --- if you want to know more about lsp-zero and mason.nvim
        --- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guide/integrate-with-mason-nvim.md
        require('mason').setup()
        require('mason-lspconfig').setup({
            handlers = {
                function(server_name)
                    if server_name == "tsserver" then
                        return
                    end
                    require('lspconfig')[server_name].setup({
                        capabilities = lsp_capabilities,
                    })
                end,
                clangd = function()
                    local clangd_cap = lsp_capabilities
                    clangd_cap.offsetEncoding = { "utf-16" }
                    require("lspconfig").clangd.setup {
                        capabilities = clangd_cap,
                        cmd = {
                            "clangd",
                            "--clang-tidy",
                            "--suggest-missing-includes",
                            "--cross-file-rename",
                        },
                    }
                end
            }
        })
        require('lspconfig').gdscript.setup(lsp_capabilities)

        require("mason-null-ls").setup({
            ensure_installed = {
                "clang-format",
                "ocamlformat",
                "typstfmt",
            },
            automatic_installation = true,
            handlers = {},
        })

        require('luasnip.loaders.from_vscode').lazy_load()
        local lspkind = require('lspkind')
        local cmp = require('cmp')
        local cmp_select = { behavior = cmp.SelectBehavior.Select }
        cmp.setup({
            sources = {
                { name = 'path' },
                { name = 'nvim_lsp' },
                { name = 'luasnip', keyword_length = 2 },
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
                format = lspkind.cmp_format()
            }
        })
    end
}
