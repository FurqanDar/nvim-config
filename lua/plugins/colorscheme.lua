return {
  'rebelot/kanagawa.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    compile      = false,
    undercurl    = true,
    transparent  = true,
    dimInactive  = false,
    terminalColors = true,

    -- Note: these are the CORRECT kanagawa keys. Old config used onedark.nvim
    -- keys (code_style.comments, code_style.keywords) which were silently ignored.
    commentStyle   = { italic = true },
    keywordStyle   = { bold = true },
    functionStyle  = {},
    statementStyle = { bold = true },
    typeStyle      = {},

    theme = 'dragon',                       -- 'wave' (standard) | 'dragon' (darker) | 'lotus' (light)
    background = { dark = 'dragon', light = 'lotus' },
  },
  config = function(_, opts)
    require('kanagawa').setup(opts)
    vim.cmd.colorscheme('kanagawa')
  end,
}
