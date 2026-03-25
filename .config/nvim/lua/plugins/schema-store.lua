-- SchemaStore.nvim — JSON and YAML schema catalogue
-- Provides a curated list of schemas from SchemaStore.org.
-- Used by the jsonls and yamlls LSP servers (configured in lsp/jsonls.lua
-- and lsp/yamlls.lua) to enable validation and autocompletion for common
-- config file formats (package.json, docker-compose.yml, GitHub Actions, etc.).
--
-- lazy = true: only loaded when explicitly required by the LSP configs,
-- not on startup.
-- version = false: the last tagged release is too old; always use HEAD.
return {
  "b0o/SchemaStore.nvim",
  lazy    = true,
  version = false,
}
