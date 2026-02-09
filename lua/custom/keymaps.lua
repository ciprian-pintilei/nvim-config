-- Navigate quickfix or location list with M-j/M-k
-- Uses location list if open, otherwise quickfix list
vim.keymap.set('n', '<M-j>', function()
  local win_info = vim.fn.getwininfo()
  for _, win in ipairs(win_info) do
    if win.loclist == 1 then
      local ok = pcall(vim.cmd, 'lnext')
      if not ok then
        vim.notify('No more items', vim.log.levels.INFO)
      end
      return
    end
  end
  local ok = pcall(vim.cmd, 'cnext')
  if not ok then
    vim.notify('No more items', vim.log.levels.INFO)
  end
end)
vim.keymap.set('n', '<M-k>', function()
  local win_info = vim.fn.getwininfo()
  for _, win in ipairs(win_info) do
    if win.loclist == 1 then
      local ok = pcall(vim.cmd, 'lprev')
      if not ok then
        vim.notify('No more items', vim.log.levels.INFO)
      end
      return
    end
  end
  local ok = pcall(vim.cmd, 'cprev')
  if not ok then
    vim.notify('No more items', vim.log.levels.INFO)
  end
end)

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>ql', vim.diagnostic.setloclist, { desc = 'Open local diagnostic [Q]uickfix list' })

vim.keymap.set('n', '<leader>qg', function()
  vim.diagnostic.setqflist {
    open = true,
    severity = nil,
  }
  -- Filter the quickfix list to exclude venv
  local qflist = vim.fn.getqflist()
  local filtered = vim.tbl_filter(function(item)
    local bufname = vim.fn.bufname(item.bufnr)
    return not bufname:match 'venv/' and not bufname:match '%.venv/'
  end, qflist)
  vim.fn.setqflist(filtered, 'r')
end, { desc = 'Open global diagnostic [Q]uickfix list' })

-- Exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Split navigation with CTRL+<hjkl>
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})
