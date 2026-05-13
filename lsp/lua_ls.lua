return {
  on_init = function(client)
    client.server_capabilities.documentFormattingProvider = nil    -- stylua via conform
  end,
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      workspace = {
        checkThirdParty = false,
        library = { vim.env.VIMRUNTIME, '${3rd}/luv/library' },
      },
      hint = { enable = true },
      completion = { callSnippet = 'Replace', showWord = 'Disable', workspaceWord = false },
      diagnostics = { disable = { 'missing-fields' }, globals = { 'vim' } },
    },
  },
}
