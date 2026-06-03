---@class LanguageModule
return {
  ensure_installed = {},
  enable = true,
  setup = function()
    local plat = "win"

    if jit.os == "Linux" then
      plat = "linux"
    elseif jit.os == "OSX" then
      plat = "macos"
    end
    local godot_node_path = vim.fn.stdpath('config') .. '/lsp_config/godot_nodepath_cs/godot-nodepath-' .. plat

    if vim.loop.fs_stat(godot_node_path) then
      vim.lsp.config.godot_node = {
        cmd = {
          godot_node_path,
        },
        root_markers = { "project.godot" },
        filetypes = { "cs" }
      }
      vim.lsp.enable({ "godot_node" })
    else
      vim.notify("godot-nodepath not found, please install it and put it into: " .. godot_node_path)
    end

    vim.lsp.enable({ "gdscript" })
  end
}
