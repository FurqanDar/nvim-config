return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-neotest/neotest-python',
    'marilari88/neotest-vitest',
    'mfussenegger/nvim-dap',
  },
  keys = {
    { '<leader>nn', function() require('neotest').run.run() end,                       desc = '[N]eotest: run [N]earest' },
    { '<leader>nf', function() require('neotest').run.run(vim.fn.expand('%')) end,     desc = '[N]eotest: run [F]ile' },
    { '<leader>nl', function() require('neotest').run.run_last() end,                  desc = '[N]eotest: run [L]ast' },
    { '<leader>nd', function() require('neotest').run.run({ strategy = 'dap' }) end,   desc = '[N]eotest: [D]ebug nearest' },
    { '<leader>nS', function() require('neotest').run.stop() end,                      desc = '[N]eotest: [S]top running' },

    { '<leader>ns', function() require('neotest').summary.toggle() end,                desc = '[N]eotest: [S]ummary panel' },
    { '<leader>no', function() require('neotest').output.open({ enter = true }) end,   desc = '[N]eotest: [O]utput (nearest)' },
    { '<leader>nO', function() require('neotest').output_panel.toggle() end,           desc = '[N]eotest: [O]utput panel' },
    { '<leader>nw', function() require('neotest').watch.toggle() end,                  desc = '[N]eotest: [W]atch nearest' },
  },
  opts = function()
    return {
      adapters = {
        require('neotest-python')({
          runner = 'pytest',
          dap = { justMyCode = false },
        }),
        require('neotest-vitest'),
      },
      status = { virtual_text = true, signs = true },
      output = { open_on_run = true },
      summary = {
        animated = false,
        mappings = { expand = { '<CR>', '<2-LeftMouse>' }, jumpto = 'i', output = 'o', run = 'r' },
      },
    }
  end,
}
