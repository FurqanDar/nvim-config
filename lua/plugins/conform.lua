return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>ff',
      function() require('conform').format({ async = true, lsp_format = 'fallback' }) end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = true,

    format_on_save = function(bufnr)
      local disable_filetypes = { c = true, cpp = true }
      if disable_filetypes[vim.bo[bufnr].filetype] then return nil end
      return {
        timeout_ms = 1500,
        lsp_format = 'fallback',                -- TS/JS/JSON/CSS → Biome's LSP
      }
    end,

    formatters_by_ft = {
      python = { 'ruff_organize_imports', 'ruff_format' },
      lua    = { 'stylua' },
      sh     = { 'shfmt' },
      bash   = { 'shfmt' },
      zsh    = { 'shfmt' },
      -- TS/JS/JSON/JSONC/CSS — intentionally NOT listed; Biome LSP owns format
      -- Markdown / YAML — intentionally NOT auto-formatted (prose mangling risk)
    },
  },
}
