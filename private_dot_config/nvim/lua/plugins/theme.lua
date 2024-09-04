return {
    "folke/tokyonight.nvim",
    lazy = false,    -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    enabled = not vim.g.vscode,
    config = function()
        -- load the color scheme here
        vim.cmd([[colorscheme tokyonight]])
    end,
}
