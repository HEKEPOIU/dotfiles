return {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
        "LazyGit",
        "LazyGitConfig",
        "LazyGitCurrentFile",
        "LazyGitFilter",
        "LazyGitFilterCurrentFile",
    },
    dependencies = {
        "nvim-lua/plenary.nvim",         -- required
        "sindrets/diffview.nvim",        -- optional - Diff integration

        "nvim-telescope/telescope.nvim", -- optional
    },
    keys = {
        { "<leader>g", "<cmd>LazyGit<cr>", desc = "LazyGit" }
    },
    config = function()
        require('telescope').load_extension('lazygit')
    end
}
