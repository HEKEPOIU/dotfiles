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
        errors = " %#DiagnosticError# " .. count["errors"]
    end
    if count["warnings"] ~= 0 then
        warnings = " %#DiagnosticWarn# " .. count["warnings"]
    end
    if count["hints"] ~= 0 then
        hints = " %#DiagnosticHint# " .. count["hints"]
    end
    if count["info"] ~= 0 then
        info = " %#DiagnosticInfo# " .. count["info"]
    end

    return errors .. warnings .. hints .. info .. "%#StatusLine#"
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
        mode_color = "%#StatusLineAccent#"
    elseif current_mode == "i" or current_mode == "ic" then
        mode_color = "%#StatusLineInsertAccent#"
    elseif current_mode == "v" or current_mode == "V" or current_mode == " " then
        mode_color = "%#StatusLineVisualAccent#"
    elseif current_mode == "R" then
        mode_color = "%#StatusLineReplaceAccent#"
    elseif current_mode == "c" then
        mode_color = "%#StatusLineCmdLineAccent#"
    elseif current_mode == "t" then
        mode_color = "%#StatusLineTerminalAccent#"
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
Statusline = {}

Statusline.active = function()
    return table.concat {
        "%#StatusLine#",
        update_mode_colors(),
        mode(),
        "%#StatusLine# ",
        filepath(),
        filename(),
        "%#StatusLine#",
        lsp(),
        "%=%#StatusLineExtra#",
        filetype(),
        lineinfo(),
    }
end

function Statusline.inactive()
    return "%#StatusLineNC# %F"
end
