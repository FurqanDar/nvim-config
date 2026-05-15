-- Clear search highlighting
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })

-- Diagnostic float at cursor (was <leader>e in old config; <leader>e is now neo-tree)
vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, { desc = '[C]ode [D]iagnostic float' })
vim.keymap.set('n', '<leader>q',  vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Terminal mode exit
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Window navigation
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Window: left' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Window: right' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Window: down' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Window: up' })

-- Visual line navigation (matters for wrapped prose/comments)
vim.keymap.set('n', 'k', 'gk', { silent = true })
vim.keymap.set('n', 'j', 'gj', { silent = true })

-- Run current Lua line/selection (handy for config development)
vim.keymap.set('n', '<leader><leader>x', '<cmd>source %<CR>', { desc = 'Source current file' })
vim.keymap.set('n', '<leader>x', ':.lua<CR>', { desc = 'Run current line in Lua' })
vim.keymap.set('v', '<leader>x', ':lua<CR>',  { desc = 'Run current selection in Lua' })

-- Toggle blink.cmp completion. Buffer-local via vim.b.completion (honored by
-- blink's default `enabled` predicate); global via vim.g.completion_enabled
-- (honored by the `enabled` function in plugins/completion.lua).
vim.keymap.set('n', '<leader>ta', function()
  vim.b.completion = (vim.b.completion == false) and true or false
  vim.notify('blink.cmp: ' .. (vim.b.completion and 'enabled' or 'disabled') .. ' (buffer)',
    vim.log.levels.INFO)
end, { desc = '[T]oggle [A]utocomplete (buffer)' })

vim.keymap.set('n', '<leader>tA', function()
  vim.g.completion_enabled = (vim.g.completion_enabled == false)
  vim.notify('blink.cmp: ' .. (vim.g.completion_enabled and 'enabled' or 'disabled') .. ' (global)',
    vim.log.levels.INFO)
end, { desc = '[T]oggle [A]utocomplete (global)' })

vim.keymap.set('n', '<leader>tu', function()
  vim.g.neotest_direct_venv = not vim.g.neotest_direct_venv
  vim.notify('neotest: ' .. (vim.g.neotest_direct_venv and '.venv direct mode' or 'uv run mode (default)'),
    vim.log.levels.INFO)
end, { desc = '[T]oggle neotest [U]v/direct mode' })
