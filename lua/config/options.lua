-- Display
vim.opt.number          = true
vim.opt.relativenumber  = false
vim.opt.mouse           = 'a'
vim.opt.showmode        = false           -- status line shows mode
vim.opt.cursorline      = false
vim.opt.scrolloff       = 15
vim.opt.signcolumn      = 'yes'
vim.opt.winborder       = 'rounded'

-- Editing
vim.opt.clipboard       = 'unnamedplus'
vim.opt.breakindent     = true
vim.opt.linebreak       = true
vim.opt.undofile        = true
vim.opt.list            = true
vim.opt.listchars       = { tab = '» ', trail = '·', nbsp = '␣' }

-- Search
vim.opt.ignorecase      = true
vim.opt.smartcase       = true
vim.opt.hlsearch        = true            -- <Esc> clears (see keymaps.lua)
vim.opt.inccommand      = 'split'

-- Splits
vim.opt.splitright      = true
vim.opt.splitbelow      = true

-- Timing
vim.opt.updatetime      = 250
vim.opt.timeoutlen      = 300

-- Folding (ufo + treesitter take over per-buffer; these are baselines)
vim.opt.foldenable      = true
vim.opt.foldlevel       = 99
vim.opt.foldlevelstart  = 99
