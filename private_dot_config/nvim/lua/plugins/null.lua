return {
    "nvimtools/none-ls.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "ThePrimeagen/refactoring.nvim",
            dependencies = {
                "nvim-lua/plenary.nvim",
                "nvim-treesitter/nvim-treesitter",
            },
            config = function()
                require("refactoring").setup(
                    {
                        -- prompt for return type
                        prompt_func_return_type = {
                            go = true,
                            cpp = true,
                            c = true,
                            java = true,
                        },
                        -- prompt for function parameters
                        prompt_func_param_type = {
                            go = true,
                            cpp = true,
                            c = true,
                            java = true,
                        },
                    }
                )
            end,
        },
    },
    enabled = not vim.g.vscode,
    config = function()
        local null_ls = require("null-ls")
        null_ls.setup {
            sources = {
                null_ls.builtins.code_actions.gitsigns,
                null_ls.builtins.formatting.gdformat,
                null_ls.builtins.diagnostics.codespell,
                null_ls.builtins.code_actions.refactoring.with({
                    filetypes = {
                        "go",
                        "javascript",
                        "lua",
                        "python",
                        "typescript",
                        "cpp",
                        "cs",
                        "csharp"
                    }
                }),
                null_ls.builtins.formatting.prettierd.with({
                    filetypes = {
                        "javascript",
                        "typescript",
                        "javascriptreact",
                        "typescriptreact",
                        "css",
                        "scss",
                        "html",
                        "json",
                        "yaml",
                        "markdown",
                        "graphql",
                        "md",
                        "txt",
                    },
                    only_local = "node_modules/.bin",
                }),
            },
            debug = true,
        }
    end
}
