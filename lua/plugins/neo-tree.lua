return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '<leader>e', '<cmd>Neotree toggle<CR>', desc = '[E]xplorer: toggle neo-tree' },
  },
  opts = {
    close_if_last_window = true,

    filesystem = {
      follow_current_file = {
        enabled = true,                          -- PyCharm-style auto-reveal
        leave_dirs_open = false,
      },
      -- Alternative (less busy): reveal only on first open
      -- follow_current_file = { enabled = false },

      filtered_items = {
        visible = false,
        hide_dotfiles = false,
        hide_gitignored = false,
        never_show = { '.DS_Store' },
      },

      use_libuv_file_watcher = true,
    },

    window = {
      position = 'left',
      width = 35,
      mappings = {
        ['<space>'] = 'none',
        ['s']       = 'open_split',
        ['v']       = 'open_vsplit',
        ['t']       = 'open_tabnew',
        ['H']       = 'toggle_hidden',
      },
    },

    default_component_configs = {
      indent = { with_markers = true, indent_marker = '│', last_indent_marker = '└' },
      git_status = {
        symbols = {
          added     = '+', modified  = '~', deleted = '✖',
          renamed   = '➜', untracked = '?', ignored = '◌',
          unstaged  = '✗', staged    = '✓', conflict = '!',
        },
      },
    },

    -- Launcher behavior: close after opening a file
    event_handlers = {
      {
        event = 'file_opened',
        handler = function()
          require('neo-tree.command').execute({ action = 'close' })
        end,
      },
    },
  },
}
