local M = {}

---@class Calculator
---@field stack number[] The stack of numbers to operate on
---@field stack_buf number? The buffer contining the stack
---@field stack_win number? The window contining the stack if one exists
---@field tail string[] The history of operations
---@field tail_buf number? The buffer contining the tail
---@field tail_win number? The window contining the stack if one exists
local Calculator = {
	stack = {},
	tail = {},
}
Calculator.__index = Calculator

function Calculator.create()
	local calculator = setmetatable({}, Calculator)
	return calculator
end

--------------------------------------------------------------------------------
--------------------------------------UI----------------------------------------
--------------------------------------------------------------------------------

function Calculator:create_ui()
	self.stack_buf = vim.api.nvim_create_buf(false, true)

	vim.api.nvim_set_option_value("filetype", "calc", { buf = self.stack_buf })

	self.stack_win = vim.api.nvim_open_win(self.stack_buf, true, {
		win = -1,
		height = 10,
		split = "below",
		style = "minimal",
	})
	self:init_stack_keymaps()
	vim.api.nvim_set_option_value("relativenumber", false, { win = self.win })

	self:draw_stack()
end

function Calculator:draw_stack()
	if not self.stack_buf then
		vim.notify("Must initialize ui before drawing", vim.log.levels.ERROR)
		return
	end
	local lines = {}
	for i, val in ipairs(self.stack) do
		table.insert(lines, string.format("% 3d", #self.stack + 1 - i) .. ": " .. tostring(val))
	end
	table.insert(lines, "     .")

	vim.api.nvim_set_option_value("modifiable", true, { buf = self.stack_buf })
	vim.api.nvim_buf_set_lines(self.stack_buf, 0, -1, false, lines)
	vim.api.nvim_set_option_value("modifiable", false, { buf = self.stack_buf })
	if self.stack_win then
		vim.api.nvim_win_set_cursor(self.stack_win, { #self.stack + 1, 0 })
	end
end

function Calculator:init_stack_keymaps()
	vim.keymap.set("n", "q", function()
		for k, _ in ipairs(self.stack) do
			self.stack[k] = nil
		end
		if self.stack_win then
			vim.api.nvim_win_close(self.stack_win, true)
		end
		vim.api.nvim_buf_delete(self.stack_buf, {})
	end, { buffer = self.stack_buf })
	vim.keymap.set("n", "0", function()
		self:insert_stack(0)
	end, { buffer = self.stack_buf })
	vim.keymap.set("n", "1", function()
		self:insert_stack(1)
	end, { buffer = self.stack_buf })
	vim.keymap.set("n", "2", function()
		self:insert_stack(2)
	end, { buffer = self.stack_buf })
	vim.keymap.set("n", "3", function()
		self:insert_stack(3)
	end, { buffer = self.stack_buf })
	vim.keymap.set("n", "4", function()
		self:insert_stack(4)
	end, { buffer = self.stack_buf })
	vim.keymap.set("n", "5", function()
		self:insert_stack(5)
	end, { buffer = self.stack_buf })
	vim.keymap.set("n", "6", function()
		self:insert_stack(6)
	end, { buffer = self.stack_buf })
	vim.keymap.set("n", "7", function()
		self:insert_stack(7)
	end, { buffer = self.stack_buf })
	vim.keymap.set("n", "8", function()
		self:insert_stack(8)
	end, { buffer = self.stack_buf })
	vim.keymap.set("n", "9", function()
		self:insert_stack(9)
	end, { buffer = self.stack_buf })
end

--------------------------------------------------------------------------------
-------------------------------Stack Management---------------------------------
--------------------------------------------------------------------------------

---@param item number The number to add to the stack
---@param index number? The position to insert it into (defaults to end)
---@param redraw boolean? Redraw the stack buffer
function Calculator:insert_stack(item, index, redraw)
	if redraw == nil then
		redraw = true
	end
	table.insert(self.stack, index or #self.stack, item)
	if redraw then
		self:draw_stack()
	end
end

---@param index number? The position to remove from (defaults to end)
---@param redraw boolean? Redraw the stack buffer
---@return number item The removed item
function Calculator:remove_stack(index, redraw)
	if redraw == nil then
		redraw = true
	end
	local item = table.remove(self.stack, index or #self.stack)
	if redraw then
		self:draw_stack()
	end
	return item
end

--------------------------------------------------------------------------------
--------------------------------Module Exports----------------------------------
--------------------------------------------------------------------------------

function M.open()
	local calculator = Calculator.create()
	calculator:create_ui()
end

return M
