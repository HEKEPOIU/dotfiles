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
    },
    keys = {
        { "<leader>g", "<cmd>LazyGit<cr>", desc = "LazyGit" }
    },
    config = function()
    end
}
