---@class LanguageModule
return {
  ensure_installed = { "ols" },
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
    local root = ""
    vim.lsp.config.ols = {
      root_dir = function(bufnr, on_dir)
        local fname = vim.api.nvim_buf_get_name(bufnr)
        if root == "" then
          root = require('lspconfig.util').root_pattern('ols.json', '.git')(fname)
        end
        on_dir(root)
      end,
    }
  end
}
