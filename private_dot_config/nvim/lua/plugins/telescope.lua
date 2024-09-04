return {
    "nvim-telescope/telescope.nvim",
    tag = '0.1.8',
    dependencies = { "nvim-lua/plenary.nvim" },
    enabled = not vim.g.vscode,
    config = function()
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = "Find Files with Telescope" })

        vim.keymap.set('n', '<leader>ps', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end, { desc = "Grep for String with Telescope" })

        vim.keymap.set('n', '<leader>pb', builtin.buffers, { desc = "List Open Buffers with Telescope" })
    end
}
