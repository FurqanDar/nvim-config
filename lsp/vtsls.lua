return {
  on_init = function(client)
    -- Biome's LSP owns TS/JS formatting
    client.server_capabilities.documentFormattingProvider = nil
    client.server_capabilities.documentRangeFormattingProvider = nil
  end,
  settings = {
    typescript = {
      inlayHints = {
        parameterNames = { enabled = 'literals' },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = false },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      },
      preferences = { importModuleSpecifier = 'shortest' },
      updateImportsOnFileMove = { enabled = 'always' },
    },
    javascript = { inlayHints = { parameterNames = { enabled = 'literals' } } },
    vtsls = {
      experimental = { completion = { enableServerSideFuzzyMatch = true } },
    },
  },
}
