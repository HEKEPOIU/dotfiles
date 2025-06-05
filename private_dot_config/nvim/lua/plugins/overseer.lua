return {
    "stevearc/overseer.nvim",
    config = function()
        require("overseer").setup({
            dap = false
        })
        vim.keymap.set("n", "<leader>or", ":OverseerRun<CR>")
        vim.keymap.set("n", "<leader>oqa", ":OverseerQuickAction<CR>")
    end
}
