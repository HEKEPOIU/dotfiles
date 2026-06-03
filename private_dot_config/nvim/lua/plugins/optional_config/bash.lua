---@class LanguageModule
return {

  ensure_installed = { "bashls" },
  enable = true,
  setup = function()
    vim.lsp.config.bashls = {
      filetypes = { "sh", "bash", "zsh" },
    }
  end
}
