return {
  'nvim-telescope/telescope.nvim',
  -- master, not 0.1.x: nvim 0.12 removed vim.treesitter.language.ft_to_lang
  -- (used by telescope previewers); only master has the get_lang replacement.
  branch = 'master',
  event = 'VimEnter',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function() return vim.fn.executable('make') == 1 end,
    },
    'nvim-telescope/telescope-ui-select.nvim',
    'nvim-tree/nvim-web-devicons',
  },

  keys = function()
    local builtin = require('telescope.builtin')
    return {
      -- Preserved from original config
      { '<leader>sh', builtin.help_tags,    desc = '[S]earch [H]elp' },
      { '<leader>sk', builtin.keymaps,      desc = '[S]earch [K]eymaps' },
      { '<leader>sf', builtin.find_files,   desc = '[S]earch [F]iles' },
      { '<leader>ss', builtin.builtin,      desc = '[S]earch [S]elect Telescope' },
      { '<leader>sw', builtin.grep_string,  desc = '[S]earch current [W]ord' },
      { '<leader>sg', builtin.live_grep,    desc = '[S]earch by [G]rep' },
      { '<leader>sd', builtin.diagnostics,  desc = '[S]earch [D]iagnostics' },
      { '<leader>sr', builtin.resume,       desc = '[S]earch [R]esume' },
      { '<leader>s.', builtin.oldfiles,     desc = '[S]earch Recent Files' },
      { '<leader><leader>', builtin.buffers, desc = '[ ] Find existing buffers' },

      { '<leader>/', function()
          builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
            winblend = 5, previewer = false,
          })
        end, desc = '[/] Fuzzily search in current buffer' },

      { '<leader>s/', function()
          builtin.live_grep { grep_open_files = true, prompt_title = 'Live Grep in Open Files' }
        end, desc = '[S]earch [/] in Open Files' },

      { '<leader>sn', function()
          builtin.find_files { cwd = vim.fn.stdpath('config') }
        end, desc = '[S]earch [N]eovim files' },

      -- Added pickers
      { '<leader>sc', builtin.commands,    desc = '[S]earch [C]ommands' },
      { '<leader>sm', builtin.marks,       desc = '[S]earch [M]arks' },
      { '<leader>sj', builtin.jumplist,    desc = '[S]earch [J]umplist' },
      { '<leader>sq', builtin.quickfix,    desc = '[S]earch [Q]uickfix list' },
      { '<leader>sT', builtin.treesitter,  desc = '[S]earch [T]reesitter symbols' },
      { '<leader>sR', builtin.registers,   desc = '[S]earch [R]egisters' },

      -- Git pickers under new <leader>g namespace
      { '<leader>gs', builtin.git_status,    desc = '[G]it [S]tatus (modified files)' },
      { '<leader>gb', builtin.git_branches,  desc = '[G]it [B]ranches' },
      { '<leader>gc', builtin.git_commits,   desc = '[G]it [C]ommits (repo)' },
      { '<leader>gf', builtin.git_bcommits,  desc = '[G]it commits for current [F]ile' },
    }
  end,

  config = function()
    local actions = require('telescope.actions')

    require('telescope').setup({
      defaults = {
        path_display = { 'truncate' },
        winblend = 5,
        layout_strategy = 'horizontal',
        layout_config = {
          horizontal = { preview_width = 0.55 },
          width  = 0.90,
          height = 0.85,
        },

        mappings = {
          i = {
            ['<C-Enter>'] = 'to_fuzzy_refine',
            ['<C-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
            ['<Esc>'] = actions.close,
          },
          n = {
            ['q'] = actions.close,
          },
        },
      },

      pickers = {
        find_files = { theme = 'dropdown', previewer = false },
        live_grep  = {
          additional_args = function() return { '--hidden', '--glob=!.git/' } end,
        },
        buffers    = { sort_lastused = true, sort_mru = true },
      },

      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown { winblend = 10 },
        },
      },
    })

    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')
  end,
}
