if vim.g.neovide then
  vim.opt.shell = "nu"
  vim.keymap.set("n", "<A-h>", "gT")
  vim.keymap.set("n", "<A-l>", "gt")
  vim.keymap.set("n", "<A-o>", ":tabmove +1<CR>")
  vim.keymap.set("n", "<A-i>", ":tabmove -1<CR>")
  vim.keymap.set({ "n", "x" }, "<C-S-V>", "\"+p")
  vim.keymap.set({ "c", "i" }, "<C-S-V>", "<C-r>+", { desc = "Paste in command mode" })
  vim.o.guifont = "0xProto Nerd Font Mono:h13"
  local ime_context = {
    base_col = 0,
    base_row = 0,
    preedit_col = 0,
    preedit_row = 0,
  }

  ---@param preedit_raw_text string
  ---@param cursor_offset [integer, integer]: [start_col, end_col]
  preedit_handler = function(preedit_raw_text, cursor_offset)
    vim.api.nvim_buf_set_text(
      0,
      ime_context.base_row - 1,
      ime_context.base_col,
      ime_context.preedit_row - 1,
      ime_context.preedit_col,
      {}
    )
    ime_context.preedit_col = ime_context.base_col + string.len(preedit_raw_text)
    vim.api.nvim_buf_set_text(
      0,
      ime_context.base_row - 1,
      ime_context.base_col,
      ime_context.base_row - 1,
      ime_context.base_col,
      { preedit_raw_text }
    )
    vim.api.nvim_win_set_cursor(0, { ime_context.preedit_row, ime_context.preedit_col })
  end
end
