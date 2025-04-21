return {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false,                                    -- Never set this value to "*"! Never!
    opts = {
        provider = "openrouter_gpt_4_1",                 -- The provider you want to use.
        cursor_applying_provider = 'openrouter_gpt_4_1', -- In this example, use Groq for applying, but you can also use any provider you want.j
        behaviour = {
            enable_cursor_planning_mode = true,         -- enable cursor planning mode!
        },
        vendors = {
            openrouter_claude = {
                __inherited_from = 'openai',
                endpoint = 'https://openrouter.ai/api/v1',
                api_key_name = 'OPENROUTER_API_KEY',
                model = 'anthropic/claude-3.7-sonnet',
            },
            openrouter_gpt_4_1 = {
                __inherited_from = 'openai',
                endpoint = 'https://openrouter.ai/api/v1',
                api_key_name = 'OPENROUTER_API_KEY',
                model = 'openai/gpt-4.1',
            }
        },
        system_prompt = function()
            local hub = require("mcphub").get_hub_instance()
            return hub:get_active_servers_prompt()
        end,
        custom_tools = function()
            return {
                require("mcphub.extensions.avante").mcp_tool(),
            }
        end,

        disabled_tools = {
            "fetch",
            "git_diff",
            "git_commit", -- Built-in git operations
            "python",
            "list_files", -- Built-in file operations
            "search_files",
            "read_file",
            "create_file",
            "rename_file",
            "delete_file",
            "create_dir",
            "rename_dir",
            "delete_dir",
            "bash", -- Built-in terminal access
        },

    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below dependencies are optional,
        "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
        "hrsh7th/nvim-cmp",              -- autocompletion for avante commands and mentions
        "nvim-tree/nvim-web-devicons",   -- or echasnovski/mini.icons
        {
            "ravitemer/mcphub.nvim",
            dependencies = {
                "nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
            },
            -- comment the following line to ensure hub will be ready at the earliest
            cmd = "MCPHub",                          -- lazy load by default
            build = "npm install -g mcp-hub@latest", -- Installs required mcp-hub npm module
            -- uncomment this if you don't want mcp-hub to be available globally or can't use -g
            -- build = "bundled_build.lua",  -- Use this and set use_bundled_binary = true in opts  (see Advanced configuration)
            config = function()
                require("mcphub").setup()
            end,
        }
    },
}
