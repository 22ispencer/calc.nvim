local M = {}

--- Evaluate a simple RPN calculation string
--- Evaluates the RPN expression from left to right
--- @param expr string The expression to evaluate
--- @return number? The calculated result
function M.eval_expr(expr)
	if type(expr) ~= "string" then
		return
	end

	local stack = { 0 }

	-- Define chunks as containing: numbers, "+", "-", "*", "/"
	for chunk in string.gmatch(expr, "([^%s]+)") do
		local num = tonumber(chunk)
		if num then
			table.insert(stack, num)
		elseif chunk == "+" then
			local add_num = table.remove(stack)
			stack[#stack] = stack[#stack] + add_num
		elseif chunk == "-" then
			local add_num = table.remove(stack)
			stack[#stack] = stack[#stack] - add_num
		elseif chunk == "*" then
			local add_num = table.remove(stack)
			stack[#stack] = stack[#stack] * add_num
		elseif chunk == "/" then
			local add_num = table.remove(stack)
			stack[#stack] = stack[#stack] / add_num
		end
	end
	return stack[#stack]
end

---@param stack number[] The stack of numbers
---@param buf number The stack buffer number
-- ---@param win number The stack buffer number
local function draw_stack(stack, buf)
	local lines = {}
	for _, val in ipairs(stack) do
		table.insert(lines, tostring(val))
	end
	table.insert(lines, ".")

	vim.api.nvim_set_option_value("modifiable", true, { buf = buf })
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
	-- vim.api.nvim_win_set_cursor(win, { #stack + 1, 0 })
end

---@param stack number[] The number stack
---@param buf number The stack buffer ID
---@param win number The stack window ID
local function stack_keymaps(stack, buf, win)
	vim.keymap.set("n", "q", function()
		for k, _ in ipairs(stack) do
			stack[k] = nil
		end
		vim.api.nvim_buf_delete(buf, {})
		vim.api.nvim_win_close(win, true)
	end, { buffer = buf })
	vim.keymap.set("n", "5", function()
		table.insert(stack, 5)
		draw_stack(stack, buf)
	end, { buffer = buf })
end

---@type number[] The stack full of numbers
M.stack = {}

function M.open()
	local stack_buf = vim.api.nvim_create_buf(false, true)

	vim.api.nvim_set_option_value("filetype", "calc", { buf = stack_buf })

	local win = vim.api.nvim_open_win(stack_buf, true, {
		win = -1,
		height = 10,
		split = "below",
	})
	stack_keymaps(M.stack, stack_buf, win)
	vim.api.nvim_set_option_value("relativenumber", false, { win = win })

	draw_stack(M.stack, stack_buf)
end

return M
