-- nvim-lspconfig — LSP server configuration defaults
-- This plugin is kept as a dependency source even though Neovim 0.11's native
-- vim.lsp.config() / vim.lsp.enable() API is used for all active server
-- configs (see the lsp/ directory).
--
-- Its value here is as a registry: nvim-lspconfig ships default `cmd`,
-- `root_markers`, and `filetypes` for every known language server, so servers
-- that don't have a hand-written lsp/*.lua file (e.g. bashls, gopls, tsgo)
-- can still be enabled with a single vim.lsp.enable("servername") call and
-- will inherit sensible defaults from lspconfig's catalogue.
--
-- The config function is intentionally empty — no setup call is needed when
-- using the native API.
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = true },
    },
    config = function()
      -- Deliberately empty: server configuration is done in lsp/*.lua files
      -- using vim.lsp.config() and vim.lsp.enable().
    end,
  },
}
