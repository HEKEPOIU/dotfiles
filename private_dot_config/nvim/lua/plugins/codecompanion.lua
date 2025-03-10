return {
    "olimorris/codecompanion.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    config = function()
        require("codecompanion").setup({
            strategies = {
                chat = {
                    adapter = "openrouter_claude",
                },
                inline = {
                    adapter = "openrouter_claude",
                },
            },
            display = {
                action_palette = {
                    width = 95,
                    height = 10,
                    prompt = "Prompt ",                     -- Prompt used for interactive LLM calls
                    provider = "telescope",                 -- default|telescope|mini_pick
                    opts = {
                        show_default_actions = true,        -- Show the default actions in the action palette?
                        show_default_prompt_library = true, -- Show the default prompt library in the action palette?
                    },
                },

                chat = {
                    window = {
                        layout = "float",     -- float|vertical|horizontal|buffer
                        position = "bottom", -- left|right|top|bottom (nil will default depending on vim.opt.plitright|vim.opt.splitbelow)
                        border = "single",
                        height = 0.8,
                        width = 0.45,
                        relative = "editor",
                        opts = {
                            breakindent = true,
                            cursorcolumn = false,
                            cursorline = false,
                            foldcolumn = "0",
                            linebreak = true,
                            list = false,
                            numberwidth = 1,
                            signcolumn = "no",
                            spell = false,
                            wrap = true,
                        },
                    },
                },
            },
            adapters = {
                openrouter_claude = function()
                    return require("codecompanion.adapters").extend("openai_compatible", {
                        env = {
                            url = "https://openrouter.ai/api",
                            api_key = "OPENROUTER_API_KEY",
                            chat_url = "/v1/chat/completions",
                        },
                        schema = {
                            model = {
                                default = "anthropic/claude-3.7-sonnet",
                            },
                        },
                    })
                end
            }
        });
    end,
}
