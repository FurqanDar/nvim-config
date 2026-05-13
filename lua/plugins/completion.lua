return {
  'saghen/blink.cmp',
  event = 'InsertEnter',
  version = '*',
  dependencies = {
    {
      'L3MON4D3/LuaSnip',
      build = (function()
        if vim.fn.has('win32') == 1 or vim.fn.executable('make') == 0 then return nil end
        return 'make install_jsregexp'
      end)(),
      dependencies = {
        {
          'rafamadriz/friendly-snippets',
          config = function()
            require('luasnip.loaders.from_vscode').lazy_load()
            require('luasnip.loaders.from_lua').lazy_load({
              paths = vim.fn.stdpath('config') .. '/luasnippets',
            })
            require('luasnip.loaders.from_vscode').lazy_load({
              paths = vim.fn.stdpath('config') .. '/snippets',
            })
          end,
        },
      },
    },
  },
  opts = {
    keymap = {
      preset = 'default',
      ['<CR>']      = { 'accept', 'fallback' },
      ['<Tab>']     = { 'select_next', 'fallback' },
      ['<S-Tab>']   = { 'select_prev', 'fallback' },
      ['<C-l>']     = { 'snippet_forward', 'fallback' },
      ['<C-h>']     = { 'snippet_backward', 'fallback' },
      ['<C-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<C-e>']     = { 'cancel', 'fallback' },
      ['<C-f>']     = { 'scroll_documentation_down', 'fallback' },
      ['<C-b>']     = { 'scroll_documentation_up', 'fallback' },
    },

    appearance = {
      use_nerd_font_variants = true,
      nerd_font_variant = 'mono',
    },

    completion = {
      accept = { auto_brackets = { enabled = true } },
      menu = {
        border = 'rounded',
        draw = { treesitter = { 'lsp' } },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        window = { border = 'rounded' },
      },
      ghost_text = { enabled = false },
    },

    snippets = { preset = 'luasnip' },

    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },

    signature = {
      enabled = true,
      window = { border = 'rounded' },
    },

    cmdline = {
      keymap = { preset = 'inherit' },
      completion = { menu = { auto_show = true } },
    },

    fuzzy = { implementation = 'prefer_rust_with_warning' },
  },
}
