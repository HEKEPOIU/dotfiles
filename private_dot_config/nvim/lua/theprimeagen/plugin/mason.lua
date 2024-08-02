require("mason").setup()
require("mason-nvim-dap").setup({
    automatic_installation = false,
    ensure_installed = {
        -- Due to a bug with the latest version of vscode-js-debug, need to lock to specific version
        -- See: https://github.com/mxsdev/nvim-dap-vscode-js/issues/58#issuecomment-2213230558
        "js@v1.76.1",
    },
})
require('mason-registry').get_package('typescript-language-server'):install({
    version = "latest"
})
