return {
    "nvim-telescope/telescope.nvim",
    tag = '0.1.8',
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = "Find Files with Telescope" })
        vim.keymap.set('n', '<leader>ph', builtin.git_files, { desc = "Find Git Files with Telescope" })

        vim.keymap.set('n', '<leader>pg', function()
            builtin.live_grep()
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
        vim.keymap.set('n', '<leader>ptd', builtin.lsp_type_definitions,
            { desc = "Goto the definition of the type of the word under the cursor" })
    end
}
