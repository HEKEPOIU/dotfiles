return {
    "stevearc/overseer.nvim",
    config = function()
        require("overseer").setup({
            dap = false,
            task_list = {
                    direction = "right",
            }
        })
        vim.keymap.set("n", "<leader>or", ":OverseerQuickAction open<CR>")
        vim.keymap.set("n", "<leader>ot", ":OverseerToggle<CR>")
    end
}
