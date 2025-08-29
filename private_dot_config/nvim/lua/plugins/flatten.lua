return {
  -- Open files and command output from wezterm, kitty, and neovim terminals in
  -- your current neovim instance
  -- https://github.com/willothy/flatten.nvim
  "willothy/flatten.nvim",

  -- Ensure that it runs first to minimize delay when opening file from terminal
  lazy = false,
  priority = 1001,

  opts = {
    window = {
      open = function(openHandler)
        local focus = openHandler.files[1]
        -- If there's an stdin buf, focus that
        if openHandler.stdin_buf then
          focus = openHandler.stdin_buf
        end
        local winnr = vim.fn.win_getid(1, 1)

        local delete_winnr = vim.fn.win_getid(vim.fn.winnr('$'), 1)
        vim.api.nvim_win_close(delete_winnr, true)
        vim.api.nvim_win_set_buf(winnr, focus.bufnr)
        vim.api.nvim_set_current_win(winnr)

        local bufnr = focus.bufnr

        return bufnr, winnr
      end,
    },
  }
}
