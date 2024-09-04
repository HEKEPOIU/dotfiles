return {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    enabled = not vim.g.vscode,
    config = true
}
