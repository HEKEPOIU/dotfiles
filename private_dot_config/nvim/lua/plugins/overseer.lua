return {
    "stevearc/overseer.nvim",
    config = true,
    enabled = not vim.g.vscode,
    opts = {
        dap = false,
    }
}
