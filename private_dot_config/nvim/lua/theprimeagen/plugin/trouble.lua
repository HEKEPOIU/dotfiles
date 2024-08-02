-- Diagnostic (Trouble)
vim.keymap.set('n', '<leader>txx', '<cmd>Trouble diagnostics toggle<cr>', { desc = 'Diagnostics (Trouble)' })

-- Buffer Diagnostics (Trouble)
vim.keymap.set('n', '<leader>txX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', { desc = 'Buffer Diagnostics (Trouble)' })

-- Symbols (Trouble)
vim.keymap.set('n', '<leader>tcs', '<cmd>Trouble symbols toggle focus=false<cr>', { desc = 'Symbols (Trouble)' })

-- LSP Definitions / references / ... (Trouble)
vim.keymap.set('n', '<leader>tcl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', { desc = 'LSP Definitions / references / ... (Trouble)' })

-- Location List (Trouble)
vim.keymap.set('n', '<leader>txL', '<cmd>Trouble loclist toggle<cr>', { desc = 'Location List (Trouble)' })

-- Quickfix List (Trouble)
vim.keymap.set('n', '<leader>txQ', '<cmd>Trouble qflist toggle<cr>', { desc = 'Quickfix List (Trouble)' })

