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

	for chunk in string.gmatch(expr, "([^%s]+)") do
		local num = tonumber(chunk)
		if num then
			table.insert(stack, num)
		elseif chunk == "+" then
			local add_num = table.remove(stack)
			stack[#stack] = stack[#stack] + add_num
		end
	end
end

return M
