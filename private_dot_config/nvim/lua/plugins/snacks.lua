return {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
        lazygit = {
            -- your lazygit configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
        bigfile = {
            -- your bigfile configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
    },
    config = function()
        vim.keymap.set("n", "<leader>g", function()
            Snacks.lazygit.open()
        end, { desc = "Lazygit" })
    end,
}
