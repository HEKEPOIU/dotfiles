local lsp_zero = require('lsp-zero')
lsp_zero.extend_lspconfig()
require("typescript-tools").setup {
    filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
        "vue",
    },
    settings = {
        tsserver_plugins = {
            "@vue/typescript-plugin",
        },
    },
}
