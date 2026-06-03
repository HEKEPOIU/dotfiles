---@class LanguageModule
return {
  ensure_installed = { "bashls" },
  enable = false,
  setup = function()
    vim.lsp.config.bashls = {
      filetypes = { "sh", "bash", "zsh" },
    }
  end
}
