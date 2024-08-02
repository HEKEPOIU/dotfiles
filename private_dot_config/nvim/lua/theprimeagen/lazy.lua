local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {
        "nvim-telescope/telescope.nvim",
        version = "0.1.6",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    {
        "nvim-treesitter/nvim-treesitter",

        build = ":TSUpdate",
    },
    {
        "mbbill/undotree",
    },
    {
        "tpope/vim-fugitive",
    },
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v3.x",
        dependencies = {
            { "neovim/nvim-lspconfig" },
            { "hrsh7th/nvim-cmp" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "L3MON4D3/LuaSnip" },
            { "williamboman/mason-lspconfig.nvim" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
        },
    },
    {
        "folke/tokyonight.nvim",
    },
    {
        "williamboman/mason.nvim",
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons", opt = true },
    },
    {
        "m4xshen/hardtime.nvim",
    },
    {
        "MunifTanjim/nui.nvim",
    },
    {
        "rafamadriz/friendly-snippets",

    },
    {
        "kylechui/nvim-surround",
        version = "*",
        config = function()
            require("nvim-surround").setup({})
        end,
    },
    {
        "nvim-tree/nvim-web-devicons",
    },
    {
        "lewis6991/gitsigns.nvim",
    },
    {
        "romgrk/barbar.nvim",
    },
    {
        "nvim-tree/nvim-tree.lua",
    },
    {
        "stevearc/overseer.nvim",
        config = true
    },
    {
        "nvim-lua/plenary.nvim",
    },
    {
        "kevinhwang91/nvim-ufo",
        dependencies = { "kevinhwang91/promise-async" },
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup {}
        end,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
    },
    {
        "HiPhish/rainbow-delimiters.nvim",
    },
    {
        "numToStr/Comment.nvim",
        config = function()
            require('Comment').setup()
        end,
    },
    {
        "gelguy/wilder.nvim",
        config = function()
            -- config goes here
        end,
    },
    {
        "iamcco/markdown-preview.nvim",
        build = function() vim.fn["mkdp#util#install"]() end,
    },
    {
        "folke/trouble.nvim",
        opts = {}, -- for default options, refer to the configuration section for custom setup.
        cmd = "Trouble",
    },
    {
        "windwp/nvim-ts-autotag",
    },
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    },
    {
        "onsails/lspkind.nvim"
    },
    {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
        opts = {},
        config = function(_, opts) require 'lsp_signature'.setup(opts) end
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" }
    },
    {
        "mxsdev/nvim-dap-vscode-js",
        requires = { "mfussenegger/nvim-dap" }
    },
    {
        "jay-babu/mason-nvim-dap.nvim"
    },
    {
        'Civitasv/cmake-tools.nvim'
    },
    {
        'akinsho/toggleterm.nvim',
        version = "*",
        config = true
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        }
    },
    {
        'kaarmu/typst.vim',
        ft = 'typst',
        lazy = false,
    },
    {
        'chomosuke/typst-preview.nvim',
        lazy = false, -- or ft = 'typst'
        version = '0.3.*',
        build = function() require 'typst-preview'.update() end,
    }
})
