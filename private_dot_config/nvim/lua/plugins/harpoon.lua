return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = {
        'nvim-lua/plenary.nvim',
        "jasonpanosso/harpoon-tabline.nvim"
    },
    config = function()
        local opts = { noremap = true, silent = true }
        local harpoon = require("harpoon")
        harpoon:setup()
        require('harpoon-tabline').setup()

        -- Go to buffer in specific position
        vim.keymap.set('n', '<leader>ha', function() harpoon:list():add() end,
            { desc = "Add to harpoon", unpack(opts) })
        vim.keymap.set('n', '<leader>hh', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
            { desc = "Open harpoon windows", unpack(opts) })

        vim.keymap.set('n', '<A-j>', function() harpoon:list():next() end,
            { desc = "Go to next buffer", unpack(opts) })
        vim.keymap.set('n', '<A-k>', function() harpoon:list():prev() end,
            { desc = "Go to prev buffer", unpack(opts) })
        vim.keymap.set('n', '<A-1>', function() harpoon:list():select(1) end,
            { desc = "Go to buffer 1", unpack(opts) })
        vim.keymap.set('n', '<A-2>', function() harpoon:list():select(2) end,
            { desc = "Go to buffer 2", unpack(opts) })
        vim.keymap.set('n', '<A-3>', function() harpoon:list():select(3) end,
            { desc = "Go to buffer 3", unpack(opts) })
        vim.keymap.set('n', '<A-4>', function() harpoon:list():select(4) end,
            { desc = "Go to buffer 4", unpack(opts) })
        vim.keymap.set('n', '<A-5>', function() harpoon:list():select(5) end,
            { desc = "Go to buffer 5", unpack(opts) })
        vim.keymap.set('n', '<A-6>', function() harpoon:list():select(6) end,
            { desc = "Go to buffer 6", unpack(opts) })
        vim.keymap.set('n', '<A-7>', function() harpoon:list():select(7) end,
            { desc = "Go to buffer 7", unpack(opts) })
        vim.keymap.set('n', '<A-8>', function() harpoon:list():select(8) end,
            { desc = "Go to buffer 8", unpack(opts) })
        vim.keymap.set('n', '<A-9>', function() harpoon:list():select(9) end,
            { desc = "Go to buffer 9", unpack(opts) })
    end
}
