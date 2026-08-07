---@class LanguageModule
return {
  ensure_installed = {},
  enable = false,
  setup = function()
    require("conform").formatters.odinfmt = {
      inherit = false,
      command = "odinfmt",
      args = { "-stdin" },
      stdin = function()
        local file_contents = vim.fn.readfile(vim.fn.expand('%'))
        return table.concat(file_contents, "\n")
      end,
    }

    vim.lsp.config.ols = {
      init_options = {
        enable_auto_import = false,
        enable_checker_only_saved = false,
        enable_fake_methods = true
      }
    }
    -- go build ols your self, mason version old, after check, ols don't release
    vim.lsp.enable("ols")
  end
}
