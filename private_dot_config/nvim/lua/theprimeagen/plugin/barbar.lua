local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Move to previous/next buffer
vim.keymap.set('n', '<A-,>', '<Cmd>BufferPrevious<CR>', { desc = "Move to previous buffer", unpack(opts) })
vim.keymap.set('n', '<A-.>', '<Cmd>BufferNext<CR>', { desc = "Move to next buffer", unpack(opts) })

-- Re-order to previous/next buffer
vim.keymap.set('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', { desc = "Move buffer to previous position", unpack(opts) })
vim.keymap.set('n', '<A->>', '<Cmd>BufferMoveNext<CR>', { desc = "Move buffer to next position", unpack(opts) })

-- Go to buffer in specific position
vim.keymap.set('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', { desc = "Go to buffer 1", unpack(opts) })
vim.keymap.set('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', { desc = "Go to buffer 2", unpack(opts) })
vim.keymap.set('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', { desc = "Go to buffer 3", unpack(opts) })
vim.keymap.set('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', { desc = "Go to buffer 4", unpack(opts) })
vim.keymap.set('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', { desc = "Go to buffer 5", unpack(opts) })
vim.keymap.set('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', { desc = "Go to buffer 6", unpack(opts) })
vim.keymap.set('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', { desc = "Go to buffer 7", unpack(opts) })
vim.keymap.set('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', { desc = "Go to buffer 8", unpack(opts) })
vim.keymap.set('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', { desc = "Go to buffer 9", unpack(opts) })
vim.keymap.set('n', '<A-0>', '<Cmd>BufferLast<CR>', { desc = "Go to last buffer", unpack(opts) })

-- Pin/unpin buffer
vim.keymap.set('n', '<A-p>', '<Cmd>BufferPin<CR>', { desc = "Pin or unpin buffer", unpack(opts) })

-- Close buffer
vim.keymap.set('n', '<A-c>', '<Cmd>BufferClose<CR>', { desc = "Close buffer", unpack(opts) })

-- Magic buffer-picking mode
vim.keymap.set('n', '<C-p>', '<Cmd>BufferPick<CR>', { desc = "Magic buffer-picking mode", unpack(opts) })

-- Sort buffers by various criteria
vim.keymap.set('n', '<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>', { desc = "Sort buffers by buffer number", unpack(opts) })
vim.keymap.set('n', '<Space>bn', '<Cmd>BufferOrderByName<CR>', { desc = "Sort buffers by name", unpack(opts) })
vim.keymap.set('n', '<Space>bd', '<Cmd>BufferOrderByDirectory<CR>', { desc = "Sort buffers by directory", unpack(opts) })
vim.keymap.set('n', '<Space>bl', '<Cmd>BufferOrderByLanguage<CR>', { desc = "Sort buffers by language", unpack(opts) })
vim.keymap.set('n', '<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>', { desc = "Sort buffers by window number", unpack(opts) })

-- Additional commands
-- :BarbarEnable - enables barbar (enabled by default)
-- :BarbarDisable - very bad command, should never be used
