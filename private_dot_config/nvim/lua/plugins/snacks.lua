local fff_files_finder = function(opts, ctx)
    local query = ctx.filter.search or ""
    local ok, result = pcall(require('fff').file_search, query, { max_results = 100 })
    if not ok or not result then return {} end
    local items = {}
    for _, item in ipairs(result.items or {}) do
        items[#items + 1] = { text = item.relative_path, file = item.relative_path }
    end
    return items
end

local fff_grep_finder = function(opts, ctx)
    local query = ctx.filter.search or ""
    if query == "" then return {} end
    local ok, result = pcall(require('fff').content_search, query, {mode = "regex" , page_size = 100, smart_case = true })
    if not ok or not result then return {} end
    local items = {}
    for _, item in ipairs(result.items or {}) do
        items[#items + 1] = { text = item.line_content, file = item.relative_path, pos = { item.line_number, item.col } }
    end
    return items
end

return {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
        lazygit = {},
        bigfile = {},
        picker = {
            win = {
                input = {
                    keys = {
                        ["<Tab>"] = { "list_down", mode = { "i", "n" } }, -- Tab 向下
                        ["<S-Tab>"] = { "list_up", mode = { "i", "n" } }, -- Shift+Tab 向上
                    }
                }
            },
            layout = {
                cycle = true,
                preset = "dropdown",
            },
            sources = {

                files = {
                    layout = { preset = "select" },
                },
                grep = {
                    layout = { preset = "ivy" },
                },
                fff_files = {
                    finder = fff_files_finder,
                    format = "file",
                    live = true,
                    supports_live = true,
                    layout = { preset = "select" },
                    matcher = { fuzzy = false, sort_empty = false },
                },
                fff_grep = {
                    enabled = false,
                    finder = fff_grep_finder,
                    format = "file",
                    live = true,
                    supports_live = true,
                    layout = { preset = "ivy" },
                    matcher = { fuzzy = false, sort_empty = false },
                },

            },
        },
        explorer = {},
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
        { "<leader>pf",  function() Snacks.picker("fff_files") end,             desc = "Find Git Files" },
        { "<leader>pg",  function() Snacks.picker("fff_grep") end,             desc = "Find Git Files" },

        -- LSP
        { "gd",          function() Snacks.picker.lsp_definitions() end,       desc = "Goto Definition" },
        { "gD",          function() Snacks.picker.lsp_declarations() end,      desc = "Goto Declaration" },
        { "<leader>pr",  function() Snacks.picker.lsp_references() end,        nowait = true,                 desc = "References" },
        { "<leader>psd", function() Snacks.picker.lsp_symbols() end,           desc = "LSP Symbols" },
        { "<leader>sS",  function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
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
  lazy = false,   -- make fff initialize on startup
}
    },
}
