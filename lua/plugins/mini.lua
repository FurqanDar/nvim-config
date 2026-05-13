return {
  'echasnovski/mini.nvim',
  event = 'VeryLazy',
  config = function()
    -- Carried forward
    require('mini.ai').setup({ n_lines = 500 })
    require('mini.surround').setup()

    local statusline = require('mini.statusline')
    statusline.setup({ use_icons = vim.g.have_nerd_font })

    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function() return '%2l:%-2v' end

    -- New additions
    require('mini.move').setup({
      -- vim-unimpaired-style. No Option (iTerm2 Esc+ punted), no Control
      -- (pinky-heavy). Horizontal moves rebound to indent-style brackets;
      -- they're rare and indent already handles the common case.
      mappings = {
        down       = ']e',  up       = '[e',
        left       = '<e',  right    = '>e',
        line_down  = ']e',  line_up  = '[e',
        line_left  = '<e',  line_right = '>e',
      },
    })

    require('mini.splitjoin').setup()

    require('mini.bracketed').setup({
      buffer     = { suffix = 'b' },
      jump       = { suffix = 'j' },
      oldfile    = { suffix = 'o' },
      treesitter = { suffix = 't' },
      window     = { suffix = 'w' },
      yank       = { suffix = 'y' },

      -- Disabled (handled elsewhere or rarely useful)
      diagnostic = { suffix = '' },    -- plugins/lsp.lua owns [d / ]d
      comment    = { suffix = '' },
      conflict   = { suffix = '' },
      file       = { suffix = '' },    -- oil handles
      indent     = { suffix = '' },
      location   = { suffix = '' },
      quickfix   = { suffix = '' },
      undo       = { suffix = '' },
    })

    -- Miller-column file explorer (Finder column view)
    require('mini.files').setup({
      options = {
        permanent_delete = false,                  -- send to trash
        use_as_default_explorer = false,           -- oil keeps `-` for floating jump-to-parent
      },
      windows = {
        preview     = true,
        width_focus = 30,
        width_nofocus = 20,
        width_preview = 40,
      },
      mappings = {
        close       = 'q',
        go_in       = 'l',
        go_in_plus  = 'L',                         -- enter file/dir, also close on file open
        go_out      = 'h',
        go_out_plus = 'H',
        reset       = '<BS>',
        reveal_cwd  = '@',
        show_help   = 'g?',
        synchronize = '=',
        trim_left   = '<',
        trim_right  = '>',
      },
    })

    vim.keymap.set('n', '<leader>F', function()
      local files = require('mini.files')
      if not files.close() then
        files.open(vim.api.nvim_buf_get_name(0), true)
      end
    end, { desc = '[F]iles: Miller-column explorer (toggle, opens at current file)' })
  end,
}
