return {
  on_init = function(client)
    -- conform.nvim owns formatting via ruff_organize_imports → ruff_format
    client.server_capabilities.documentFormattingProvider = nil
    client.server_capabilities.documentRangeFormattingProvider = nil
    -- basedpyright owns hover (richer type info than ruff's lint hover)
    client.server_capabilities.hoverProvider = nil
    -- Match basedpyright's UTF-16 to avoid Position Encodings mismatch warning
    client.offset_encoding = 'utf-16'
  end,
}
