vim.g.mapleader = " "

vim.opt.iskeyword:append("_")


vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected text down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected text up" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and maintain cursor position" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result and center" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result and center" })

vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste and keep selection" })

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yanking" })

vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Exit insert mode" })

vim.keymap.set("n", "Q", "<nop>", { desc = "Disable Ex mode" })
vim.keymap.set("n", "<C-j>", function()
    local qf_list = vim.fn.getqflist()
    if #qf_list == 0 then
        vim.notify("Quickfix list is empty", vim.log.levels.WARN)
    elseif #qf_list == 1 then
        vim.cmd("cc 1")
        vim.cmd("normal! zz")
    else
        vim.cmd("try|cnext | catch |endtry")
        vim.cmd("normal! zz")
    end
end, { desc = "Next item in quickfix list" })
vim.keymap.set("n", "<C-k>", function()
    local qf_list = vim.fn.getqflist()
    if #qf_list == 0 then
        vim.notify("Quickfix list is empty", vim.log.levels.WARN)
    elseif #qf_list == 1 then
        vim.cmd("cc 1")
        vim.cmd("normal! zz")
    else
        vim.cmd("try|cprev | catch |endtry")
        vim.cmd("normal! zz")
    end
end, { desc = "Previous item in quickfix list" })
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "Next item in location list" })
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "Previous item in location list" })
vim.keymap.set("n", "<leader>cf", "<cmd>let @+ = expand('%:.')<CR>", { desc = "Copy file path to clipboard" })

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Replace word under cursor" })
