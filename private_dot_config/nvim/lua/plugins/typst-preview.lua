return {
    'chomosuke/typst-preview.nvim',
    lazy = false,             -- or ft = 'typst'
    version = '0.3.*',
    enabled = not vim.g.vscode,
    build = function() require 'typst-preview'.update() end,
}
