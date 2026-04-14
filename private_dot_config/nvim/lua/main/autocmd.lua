vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
	pattern = "*",
	desc = "highlight selection on yank",
	callback = function()
		vim.highlight.on_yank({ timeout = 200, visual = true })
	end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function(args)
		local exclude = { "gitcommit", "gitrebase", "terminal" }
		local buf_ft = vim.bo[args.buf].filetype
		local buf_bt = vim.bo[args.buf].buftype

		if vim.tbl_contains(exclude, buf_ft) or buf_bt ~= "" then
			return
		end


		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		local line_count = vim.api.nvim_buf_line_count(args.buf)
		if mark[1] > 0 and mark[1] <= line_count then
			vim.api.nvim_win_set_cursor(0, mark)
			-- defer centering slightly so it's applied after render
			vim.schedule(function()
				vim.cmd("normal! zz")
			end)
		end
	end,
})

vim.api.nvim_create_autocmd("VimResized", {
	command = "wincmd =",
})

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("no_auto_comment", {}),
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})

--#region Show error on hold.
local ns = vim.api.nvim_create_namespace("my_diagnostics_ns")

vim.diagnostic.config({
	virtual_text = false,
	underline = true,
})

vim.api.nvim_create_autocmd("CursorHold", {
	callback = function()
		local bufnr = vim.api.nvim_get_current_buf()
		local cursor = vim.api.nvim_win_get_cursor(0)
		local lnum = cursor[1] - 1
		local diagnostics = vim.diagnostic.get(bufnr, { lnum = lnum })


		if #diagnostics > 0 then
			vim.diagnostic.show(ns, bufnr, diagnostics, {
				virtual_text = true,
			})
		end
	end,
})

vim.api.nvim_create_autocmd("CursorMoved", {
	callback = function()
		vim.diagnostic.hide(ns)
		vim.diagnostic.config({
			virtual_text = false,
			underline = true,
		})
	end,
})
--#endregion Show error on hold.



require("main.stateline")

local statusline_group = vim.api.nvim_create_augroup("Statusline", { clear = true })

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
    group = statusline_group,
    callback = function()
        vim.opt_local.statusline = "%!v:lua.Statusline.active()"
    end,
})

vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
    group = statusline_group,
    callback = function()
        vim.opt_local.statusline = "%!v:lua.Statusline.inactive()"
    end,
})
