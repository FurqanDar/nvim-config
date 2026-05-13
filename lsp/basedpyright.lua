return {
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = 'standard',          -- 'off' / 'basic' / 'standard' / 'strict'
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,

        diagnosticMode = 'workspace',           -- vault-wide diagnostics
        -- diagnosticMode = 'openFilesOnly',    -- faster on big repos; uncomment if slow

        inlayHints = {
          variableTypes = true,
          callArgumentNames = true,
          functionReturnTypes = true,
          genericTypes = false,
        },
      },
    },
  },
}
