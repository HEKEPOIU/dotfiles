---@class LanguageModule
return {
  ensure_installed = { "clangd", "neocmake", "mesonlsp" },
  enable = true,
  setup = function()
    local function get_clangd_cmd()
      local project_path = vim.fn.getcwd() -- Get the current project directory

      -- Define the paths for Mason and Xcode clangd
      local mason_clangd = "clangd"
      local xcode_clangd = "/usr/bin/clangd"

      -- Define project-specific rules
      if string.match(project_path, ".*XcodeProject.*") then
        return xcode_clangd
      else
        return mason_clangd
      end
    end

    vim.lsp.config.clangd = {
      capabilities = require('blink.cmp').get_lsp_capabilities({
        offsetEncoding = { "utf-16" },
      }),
      cmd = {
        get_clangd_cmd(),
        "--background-index",
        "--header-insertion-decorators",
        "--header-insertion=never",
        "--background-index-priority=normal",
        "--enable-config",
        "--clang-tidy",
      },
    }
  end
}
