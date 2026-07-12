---@class LanguageModule
return {
  ensure_installed = {},
  enable = true,
  setup = function()
    -- The Mason Version are odd, download preview version of serve_d on github manually
    vim.lsp.enable({ "serve_d" })
    end
}
