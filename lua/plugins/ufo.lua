return {
  'kevinhwang91/nvim-ufo',
  dependencies = { 'kevinhwang91/promise-async' },
  event = 'BufReadPost',

  init = function()
    vim.o.foldcolumn      = '1'
    vim.o.foldlevel       = 99
    vim.o.foldlevelstart  = 99
    vim.o.foldenable      = true
  end,

  config = function()
    require('ufo').setup({
      provider_selector = function(bufnr, filetype, buftype)
        -- Skip transient/special buffers — they have no LSP and no parser, so
        -- both providers throw UfoFallbackException into :messages.
        if buftype ~= '' then return '' end
        local skip_ft = {
          ['minifiles']       = true,
          ['minifiles-window'] = true,
          ['undotree']        = true,
          ['diff']            = true,
          ['neo-tree']        = true,
          ['oil']             = true,
          ['help']            = true,
          ['lazy']            = true,
          ['mason']           = true,
          ['fugitive']        = true,
        }
        if skip_ft[filetype] or filetype:match('^dapui') or filetype:match('^minifiles') then
          return ''
        end
        return { 'lsp', 'treesitter' }
      end,
      preview = {
        win_config = {
          border       = 'rounded',
          winhighlight = 'Normal:Folded',
          winblend     = 0,
        },
        mappings = {
          scrollU = '<C-u>',
          scrollD = '<C-d>',
        },
      },
    })

    -- Fold open/close keymaps
    vim.keymap.set('n', 'zR', require('ufo').openAllFolds,         { desc = 'Open all folds' })
    vim.keymap.set('n', 'zM', require('ufo').closeAllFolds,        { desc = 'Close all folds' })
    vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds, { desc = 'Open folds except kinds' })
    vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith,       { desc = 'Close folds with level' })

    -- Smart K: peek fold if on closed fold; else fall through to LSP hover.
    -- vim.lsp.buf.hover() is safe no-op when no LSP attached.
    vim.keymap.set('n', 'K', function()
      local winid = require('ufo').peekFoldedLinesUnderCursor()
      if winid then return end
      vim.lsp.buf.hover()
    end, { desc = 'Peek fold / LSP hover' })
  end,
}
