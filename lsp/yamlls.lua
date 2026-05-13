return {
  settings = {
    yaml = {
      schemaStore = { enable = false, url = '' },    -- disable yamlls's built-in catalog
      schemas = require('schemastore').yaml.schemas(),
      keyOrdering = false,
    },
  },
}
