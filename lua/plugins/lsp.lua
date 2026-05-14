return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'mason-org/mason.nvim', opts = {} },
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'j-hui/fidget.nvim', opts = {} },
    'b0o/SchemaStore.nvim',
    'saghen/blink.cmp',
  },
  config = function()
    -- ============== Diagnostic display ==============
    vim.diagnostic.config({
      severity_sort = true,
      float = { border = 'rounded', source = 'if_many' },
      underline = { severity = vim.diagnostic.severity.ERROR },
      signs = vim.g.have_nerd_font and {
        text = {
          [vim.diagnostic.severity.ERROR] = '󰅚 ',
          [vim.diagnostic.severity.WARN]  = '󰀪 ',
          [vim.diagnostic.severity.INFO]  = '󰋽 ',
          [vim.diagnostic.severity.HINT]  = '󰌶 ',
        },
      } or {},
      virtual_text = {
        source = 'if_many',
        spacing = 2,
        format = function(d) return d.message end,
      },
    })

    -- ============== Diagnostic navigation (new vim.diagnostic.jump API) ==============
    vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = 'Previous [D]iagnostic' })
    vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count =  1, float = true }) end, { desc = 'Next [D]iagnostic' })

    -- ============== Buffer-local keymaps on LSP attach ==============
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('user-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- telescope arrives in Commit 6; until then, fall back to native LSP pickers
        local ok_tel, builtin = pcall(require, 'telescope.builtin')
        if ok_tel then
          map('gd', builtin.lsp_definitions,         '[G]oto [D]efinition')
          map('gr', builtin.lsp_references,          '[G]oto [R]eferences')
          map('gI', builtin.lsp_implementations,     '[G]oto [I]mplementation')
          map('<leader>cD', builtin.lsp_type_definitions, 'Type [D]efinition')
          map('<leader>ds', builtin.lsp_document_symbols, '[D]ocument [S]ymbols')
          map('<leader>ws', builtin.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        else
          map('gd', vim.lsp.buf.definition,      '[G]oto [D]efinition')
          map('gr', vim.lsp.buf.references,      '[G]oto [R]eferences')
          map('gI', vim.lsp.buf.implementation,  '[G]oto [I]mplementation')
          map('<leader>cD', vim.lsp.buf.type_definition,  'Type [D]efinition')
          map('<leader>ds', vim.lsp.buf.document_symbol,  '[D]ocument [S]ymbols')
          map('<leader>ws', vim.lsp.buf.workspace_symbol, '[W]orkspace [S]ymbols')
        end

        -- NOTE: K is intentionally NOT mapped here. plugins/ufo.lua sets a global
        -- smart-K that does peek-fold-then-LSP-hover fallback.
        map('gD', vim.lsp.buf.declaration,         '[G]oto [D]eclaration')
        map('<leader>rn', vim.lsp.buf.rename,      '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

        local client = vim.lsp.get_client_by_id(event.data.client_id)

        if client and client:supports_method('textDocument/documentHighlight') then
          local hl_group = vim.api.nvim_create_augroup('user-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf, group = hl_group, callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf, group = hl_group, callback = vim.lsp.buf.clear_references,
          })
          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('user-lsp-detach', { clear = true }),
            callback = function(e2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds({ group = 'user-lsp-highlight', buffer = e2.buf })
            end,
          })
        end

        if client and client:supports_method('textDocument/inlayHint') then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    -- ============== Capabilities (blink.cmp augments after Commit 4) ==============
    local ok_blink, blink = pcall(require, 'blink.cmp')
    if ok_blink then
      vim.lsp.config('*', { capabilities = blink.get_lsp_capabilities() })
    end

    -- ============== Mason: install LSP servers and CLI tools ==============
    local servers = {
      'basedpyright', 'ruff',
      'vtsls', 'biome', 'tailwindcss', 'emmet_language_server',
      'jsonls', 'yamlls', 'html', 'cssls',
      'lua_ls',
      'tinymist',
    }

    require('mason-lspconfig').setup({
      ensure_installed = servers,
      automatic_enable = false,                   -- we control enablement via vim.lsp.enable
    })

    require('mason-tool-installer').setup({
      ensure_installed = {
        'stylua',                                 -- Lua formatter (conform)
        'shfmt',                                  -- shell formatter (conform)
        'markdownlint',                           -- Markdown linter (nvim-lint)
        'vale',                                   -- Prose linter (nvim-lint)
        'shellcheck',                             -- Shell linter (nvim-lint)
        'hadolint',                               -- Dockerfile linter (nvim-lint)
        'yamllint',                               -- YAML linter (nvim-lint)
        'debugpy',                                -- Python debugger (dap-python)
        'codelldb',                               -- Native debugger for Zig/C/C++/Rust (DAP)
      },
    })

    vim.lsp.enable(servers)
  end,
}
