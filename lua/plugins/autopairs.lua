return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  dependencies = {
    {
      'windwp/nvim-ts-autotag',
      opts = {
        opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = false,
        },
      },
    },
  },
  opts = {
    check_ts = true,
    ts_config = {
      lua = { 'string', 'source' },
      javascript = { 'string', 'template_string' },
      python = { 'string' },
    },
    disable_filetype = { 'TelescopePrompt' },
    fast_wrap = {
      -- <M-e> per the plan; M= depends on iTerm2 Option=Esc+ which we punted.
      -- Leaving plan's default for now; rebind if fast_wrap ever proves useful.
      map = '<M-e>',
      chars = { '{', '[', '(', '"', "'" },
      pattern = [=[[%'%"%>%]%)%}%,]]=],
      end_key = '$',
      keys = 'qwertyuiopzxcvbnmasdfghjkl',
      check_comma = true,
      highlight = 'Search',
      highlight_grey = 'Comment',
    },
  },
}
