local grep_directory = function()
    local snacks = require("snacks")
    local cwd = vim.fn.getcwd()

    local function show_picker(dirs)
        if #dirs == 0 then
            vim.notify("No directories found", vim.log.levels.WARN)
            return
        end

        local items = {}
        for i, item in ipairs(dirs) do
            table.insert(items, {
                idx = i,
                file = item,
                text = item,
            })
        end

        snacks.picker({
            confirm = function(picker, item)
                picker:close()
                snacks.picker.grep({
                    dirs = { item.file },
                })
            end,
            items = items,
            format = function(item, _)
                local file = item.file
                local ret = {}
                local a = Snacks.picker.util.align
                local icon, icon_hl = Snacks.util.icon(file.ft, "directory")
                ret[#ret + 1] = { a(icon, 3), icon_hl }
                ret[#ret + 1] = { " " }
                local path = file:gsub("^" .. vim.pesc(cwd) .. "/", "")
                ret[#ret + 1] = { a(path, 20), "Directory" }

                return ret
            end,
            layout = {
                preview = false,
                preset = "vertical",
            },
            title = "Grep in directory",
        })
    end
    local dirs = require("plenary.scandir").scan_dir(cwd, {
        only_dirs = true,
        respect_gitignore = false,
    })
    show_picker(dirs)
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
        { "<leader>pg",  function() Snacks.picker.grep() end,                  desc = "Grep" },
        { "<leader>pb",  function() Snacks.picker.buffers() end,               desc = "Buffers" },
        { "<leader>ph",  function() Snacks.picker.git_files() end,             desc = "Find Git Files" },
        { "<leader>pd",  grep_directory,                                       desc = "Find Dir File" },
        { "<leader>pf",  function() Snacks.picker.files() end,                 desc = "Find Files" },

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
    },
}
