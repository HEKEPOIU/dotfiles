local function lsp()
    local count = {}
    local levels = {
        errors = "Error",
        warnings = "Warn",
        info = "Info",
        hints = "Hint",
    }

    for k, level in pairs(levels) do
        count[k] = vim.tbl_count(vim.diagnostic.get(0, { severity = level }))
    end

    local errors = ""
    local warnings = ""
    local hints = ""
    local info = ""

    if count["errors"] ~= 0 then
        errors = " %#LspDiagnosticsSignError# " .. count["errors"]
    end
    if count["warnings"] ~= 0 then
        warnings = " %#LspDiagnosticsSignWarning# " .. count["warnings"]
    end
    if count["hints"] ~= 0 then
        hints = " %#LspDiagnosticsSignHint# " .. count["hints"]
    end
    if count["info"] ~= 0 then
        info = " %#LspDiagnosticsSignInformation# " .. count["info"]
    end

    return errors .. warnings .. hints .. info .. "%#Normal#"
end
local function filename()
    local fname = vim.fn.expand "%:t"
    if fname == "" then
        return ""
    end
    return fname .. " "
end
local function filepath()
    local fpath = vim.fn.fnamemodify(vim.fn.expand "%", ":~:.:h")
    if fpath == "" or fpath == "." then
        return " "
    end

    return string.format(" %%<%s/", fpath)
end
local function update_mode_colors()
    local current_mode = vim.api.nvim_get_mode().mode
    local mode_color = "%#StatusLineAccent#"
    if current_mode == "n" then
        mode_color = "%#StatuslineAccent#"
    elseif current_mode == "i" or current_mode == "ic" then
        mode_color = "%#StatuslineInsertAccent#"
    elseif current_mode == "v" or current_mode == "V" or current_mode == " " then
        mode_color = "%#StatuslineVisualAccent#"
    elseif current_mode == "R" then
        mode_color = "%#StatuslineReplaceAccent#"
    elseif current_mode == "c" then
        mode_color = "%#StatuslineCmdLineAccent#"
    elseif current_mode == "t" then
        mode_color = "%#StatuslineTerminalAccent#"
    end
    return mode_color
end
local modes = {
    ["n"] = "NORMAL",
    ["no"] = "NORMAL",
    ["v"] = "VISUAL",
    ["V"] = "VISUAL LINE",
    ["\22"] = "VISUAL BLOCK",
    ["s"] = "SELECT",
    ["S"] = "SELECT LINE",
    ["\19"] = "SELECT BLOCK",
    ["i"] = "INSERT",
    ["ic"] = "INSERT",
    ["R"] = "REPLACE",
    ["Rv"] = "VISUAL REPLACE",
    ["c"] = "COMMAND",
    ["cv"] = "VIM EX",
    ["ce"] = "EX",
    ["r"] = "PROMPT",
    ["rm"] = "MOAR",
    ["r?"] = "CONFIRM",
    ["!"] = "SHELL",
    ["t"] = "TERMINAL",
}
local function mode()
    local current_mode = vim.api.nvim_get_mode().mode
    return string.format(" %s ", modes[current_mode] or current_mode):upper()
end

local function filetype()
    return string.format(" %s ", vim.bo.filetype)
end
local function lineinfo()
    if vim.bo.filetype == "alpha" then
        return ""
    end
    return " %P %l:%c "
end
local function set_hl()
    -- 背景底色（整條 statusline）
    vim.api.nvim_set_hl(0, "Statusline", { bg = "#1e1e2e", fg = "#cdd6f4" })

    -- 模式區塊的顏色
    vim.api.nvim_set_hl(0, "StatuslineAccent", { bg = "#89b4fa", fg = "#1e1e2e", bold = true })        -- Normal
    vim.api.nvim_set_hl(0, "StatuslineInsertAccent", { bg = "#a6e3a1", fg = "#1e1e2e", bold = true })  -- Insert
    vim.api.nvim_set_hl(0, "StatuslineVisualAccent", { bg = "#cba6f7", fg = "#1e1e2e", bold = true })  -- Visual
    vim.api.nvim_set_hl(0, "StatuslineReplaceAccent", { bg = "#f38ba8", fg = "#1e1e2e", bold = true }) -- Replace
    vim.api.nvim_set_hl(0, "StatuslineCmdLineAccent", { bg = "#f9e2af", fg = "#1e1e2e", bold = true }) -- Command
    vim.api.nvim_set_hl(0, "StatuslineTerminalAccent", { bg = "#94e2d5", fg = "#1e1e2e", bold = true }) -- Terminal

    -- 右側 filetype / lineinfo 區塊
    vim.api.nvim_set_hl(0, "StatusLineExtra", { bg = "#313244", fg = "#cdd6f4" })

    -- LSP 診斷圖示顏色
    vim.api.nvim_set_hl(0, "LspDiagnosticsSignError", { fg = "#f38ba8" })
    vim.api.nvim_set_hl(0, "LspDiagnosticsSignWarning", { fg = "#f9e2af" })
    vim.api.nvim_set_hl(0, "LspDiagnosticsSignHint", { fg = "#94e2d5" })
    vim.api.nvim_set_hl(0, "LspDiagnosticsSignInformation", { fg = "#89b4fa" })
end

set_hl()

Statusline = {}

Statusline.active = function()
    return table.concat {
        "%#Statusline#",
        update_mode_colors(),
        mode(),
        "%#Normal# ",
        filepath(),
        filename(),
        "%#Normal#",
        lsp(),
        "%=%#StatusLineExtra#",
        filetype(),
        lineinfo(),
    }
end

function Statusline.inactive()
    return " %F"
end
