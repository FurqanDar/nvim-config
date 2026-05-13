return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
  event = { 'BufReadPre', 'BufNewFile' },
  opts = {
    indent = { char = '│' },
    scope = {
      enabled = true,
      show_start = false,
      show_end = false,
    },
    exclude = {
      filetypes = {
        'help', 'lazy', 'mason', 'neo-tree', 'oil',
        'TelescopePrompt', 'TelescopeResults',
        'dapui_scopes', 'dapui_breakpoints', 'dapui_stacks',
        'dapui_watches', 'dapui_console',
      },
    },
  },
}
