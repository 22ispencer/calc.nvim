(local M {})

(set M.stack [])

(fn M.hello []
  (print "Hello, World"))

(fn draw_stack [stack buf win]
  (local lines [])
  (each [_ value (ipairs stack)]
    (table.insert lines (tostring value)))
  (table.insert lines ".")
  (vim.api.nvim_win_set_cursor 0 [1 (length lines)])
  (vim.api.nvim_set_option_value :modifiable true {: buf})
  (vim.api.nvim_buf_set_lines buf 0 -1 false lines)
  (vim.api.nvim_set_option_value :modifiable false {: buf}))

(fn stack_keymaps [stack buf win]
  (vim.keymap.set "n" "q" (fn [] 
			    (each [k _ (ipairs stack)]
			      (set (. stack k) nil))
			    (vim.api.nvim_win_close win true)
			    (vim.api.nvim_buf_delete buf {}))
		  {:buffer buf})
  (vim.keymap.set "n" "5" (fn []
			    (table.insert stack 5)
			    (draw_stack stack buf))))

(fn M.open []
  (set M.stack_buf (vim.api.nvim_create_buf false true))
  (vim.api.nvim_set_option_value :filetype :calc {:buf M.stack_buf})
  (set M.win (vim.api.nvim_open_win M.stack_buf true {:win -1 :height 10 :split :below}))
  (stack_keymaps M.stack M.stack_buf M.win)
  (vim.api.nvim_set_option_value :relativenumber false {:win M.win})
  (draw_stack M.stack M.stack_buf M.win))

M
