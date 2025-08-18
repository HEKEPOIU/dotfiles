return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-ui-select.nvim",
        "princejoogie/dir-telescope.nvim",
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            build =
            'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release -DCMAKE_POLICY_VERSION_MINIMUM=3.5 && cmake --build build --config=Release && cmake --install build'
        },
        {
            "nvim-telescope/telescope-live-grep-args.nvim",
        },
    },
    config = function()
        local builtin = require('telescope.builtin')
        require("dir-telescope").setup({
            -- these are the default options set
            hidden = true,
            no_ignore = true,
            show_preview = true,
            follow_symlinks = true,
        })
        vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = "Find Files with Telescope" })
        vim.keymap.set('n', '<leader>ph', builtin.git_files, { desc = "Find Git Files with Telescope" })

        vim.keymap.set('n', '<leader>pg', function()
            require('telescope').extensions.live_grep_args.live_grep_args()
        end, { desc = "Live Grep with Telescope" })

        vim.keymap.set('n', '<leader>pb', builtin.buffers, { desc = "List Open Buffers with Telescope" })
        vim.keymap.set('n', '<leader>pr', builtin.lsp_references,
            { desc = "Lists LSP references for word under the cursor" })
        vim.keymap.set('n', '<leader>psd', builtin.lsp_document_symbols,
            { desc = "Lists LSP document symbols in the current buffer" })

        vim.keymap.set('n', '<leader>psa', builtin.lsp_dynamic_workspace_symbols,
            { desc = "Dynamically Lists LSP for all workspace symbols" })

        vim.keymap.set('n', '<leader>pi', builtin.lsp_implementations,
            { desc = "Goto the implementation of the word under the cursor" })
        vim.keymap.set('n', 'gd', builtin.lsp_definitions,
            { desc = "Go to definition" })


        vim.keymap.set('n', '<leader>pd', builtin.lsp_definitions,
            { desc = "Goto the definition of the word under the cursor" })
        require('telescope').setup {
            pickers = {
                find_files = {
                    theme = "dropdown",
                },
                git_files = {
                    theme = "dropdown",
                },
                live_grep = {
                    theme = "ivy",
                },
                buffers = {
                    theme = "dropdown",
                },
                lsp_references = {
                    theme = "dropdown",
                },
                lsp_document_symbols = {
                    theme = "dropdown",
                },
                lsp_dynamic_workspace_symbols = {
                    theme = "dropdown",
                },
                lsp_implementations = {
                    theme = "dropdown",
                },
                lsp_definitions = {
                    theme = "dropdown",
                },
                lsp_type_definitions = {
                    theme = "dropdown",
                },
            },
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown()
                },
                fzf = {
                    fuzzy = true,                   -- false will only do exact matching
                    override_generic_sorter = true, -- override the generic sorter
                    override_file_sorter = true,    -- override the file sorter
                    case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
                    -- the default case_mode is "smart_case"
                },
                live_grep_args = {
                    mappings = {       -- extend mappings
                        i = {
                            ["<C-k>"] = require("telescope-live-grep-args.actions").quote_prompt(),
                        },
                    },
                    theme = "ivy",
                }
            }

        }
        require('telescope').load_extension('ui-select')
        require('telescope').load_extension('fzf')
        require("telescope").load_extension("dir")
        require("telescope").load_extension("live_grep_args")
    end
}
