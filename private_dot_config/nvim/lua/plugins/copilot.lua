return {
    "github/copilot.vim",
    config = function()
        -- Disable the default Tab mapping for Copilot
        vim.g.copilot_no_tab_map = true

        -- Set custom mapping for accepting suggestions
        vim.keymap.set('i', '<C-\\>', 'copilot#Accept("\\<CR>")', {
            expr = true,
            replace_keycodes = false
        })
    end,
}
