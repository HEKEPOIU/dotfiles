vim.api.nvim_create_user_command("FindFile", function(opts)
    local target_dir = opts.args ~= "" and vim.fn.expand(opts.args) or vim.fn.getcwd()

    require('fff').find_files_in_dir(target_dir)
end, {
    nargs = "?",
    complete = "dir_in_path",
})

vim.api.nvim_create_user_command("GrepFile", function(opts)
    local target_dir = opts.args ~= "" and vim.fn.expand(opts.args) or vim.fn.getcwd()
    require('fff').live_grep({ cwd = target_dir, title = "FFF Grep: " .. vim.fn.fnamemodify(target_dir, ":t") })

end, {
    nargs = "?",
    complete = "dir_in_path",
})


return {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
        lazygit = {},
        bigfile = {},
        picker = {
            layout = {
                cycle = true,
                preset = "dropdown",
            },
        },
        indent = {},
        quickfile = {},
        rename = {
            config = function()
                vim.api.nvim_create_autocmd("User", {
                    pattern = "OilActionsPost",
                    callback = function(event)
                        if event.data.actions[1].type == "move" then
                            Snacks.rename.on_rename_file(event.data.actions[1].src_url, event.data.actions[1].dest_url)
                        end
                    end,
                })
            end
        },
        image = {},

    },
    keys = {
        -- Top Pickers & Explorer
        { "<leader>pb",  function() Snacks.picker.buffers() end,               desc = "Buffers" },
        { "<leader>ph",  function() Snacks.picker.git_files() end,             desc = "Find Git Files" },

        -- LSP
        { "gd",          function() Snacks.picker.lsp_definitions() end,       desc = "Goto Definition" },
        { "gri",          function() Snacks.picker.lsp_declarations() end,      desc = "Goto Declaration" },
        { "<leader>pr",  function() Snacks.picker.lsp_references() end,        nowait = true,                 desc = "References" },
        { "gO", function() Snacks.picker.lsp_symbols() end,           desc = "LSP Symbols" },
        { "<leader>g",   function() Snacks.lazygit.open() end,                 desc = "Goto Implementation" },
    },
    lazy = false,
    priority = 1000,
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "dmtrKovalenko/fff.nvim",
            build = function()
                require("fff.download").download_or_build_binary()
            end,
            lazy = false, -- make fff initialize on startup
            keys = {
                { "<leader>pg", function() require('fff').live_grep() end,  desc = 'LiFFFe grep' },
                { "<leader>pf", function() require('fff').find_files() end, desc = 'LiFFFe grep' },
                {
                    "<leader>pw",
                    function() require('fff').live_grep_under_cursor() end,
                    mode = { 'n', 'x' },
                    desc = 'Search current word / selection',
                },
            },
            opts = {
                layout = {
                    anchor = 'bottom',
                    height = 0.4,
                    width = 1,
                    prompt_position = 'top',
                },
                keymaps = {
                    close = '<Esc>',
                    select = '<CR>',
                    select_split = '<C-s>',
                    select_vsplit = '<C-v>',
                    select_tab = '<C-t>',
                    move_up = { '<Up>', '<C-p>' },
                    move_down = { '<Down>', '<C-n>' },
                    preview_scroll_up = '<C-u>',
                    preview_scroll_down = '<C-d>',
                    toggle_debug = '<F2>',
                    cycle_grep_modes = '<S-Tab>',
                    -- grep mode only: jump cursor to first match of next/prev file group
                    grep_jump_to_next_file = { '<C-A-n>', '<A-Down>' },
                    grep_jump_to_prev_file = { '<C-A-p>', '<A-Up>' },
                    cycle_previous_query = '<C-Up>',
                    toggle_select = '<Tab>',
                    send_to_quickfix = '<C-q>',
                    focus_list = '<leader>l',
                    focus_preview = '<leader>p',
                },
            }
        }
    },
}
