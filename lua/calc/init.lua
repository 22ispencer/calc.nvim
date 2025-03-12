-- [nfnl] Compiled from fnl/calc/init.fnl by https://github.com/Olical/nfnl, do not edit.
local M = {}
M.stack = {}
M.hello = function()
	return print("Hello, World")
end
local function draw_stack(stack, buf, win)
	local lines = {}
	for _, value in ipairs(stack) do
		table.insert(lines, tostring(value))
	end
	table.insert(lines, ".")
	vim.api.nvim_win_set_cursor(0, { 1, #lines })
	vim.api.nvim_set_option_value("modifiable", true, { buf = buf })
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	return vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
end
local function stack_keymaps(stack, buf, win)
	local function _1_()
		for k, _ in ipairs(stack) do
			stack[k] = nil
		end
		vim.api.nvim_win_close(win, true)
		return vim.api.nvim_buf_delete(buf, {})
	end
	vim.keymap.set("n", "q", _1_, { buffer = buf })
	local function _2_()
		table.insert(stack, 5)
		return draw_stack(stack, buf)
	end
	return vim.keymap.set("n", "5", _2_)
end
M.open = function()
	M.stack_buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_set_option_value("filetype", "calc", { buf = M.stack_buf })
	M.win = vim.api.nvim_open_win(M.stack_buf, true, { win = -1, height = 10, split = "below" })
	stack_keymaps(M.stack, M.stack_buf, M.win)
	vim.api.nvim_set_option_value("relativenumber", false, { win = M.win })
	return draw_stack(M.stack, M.stack_buf, M.win)
end
return M
