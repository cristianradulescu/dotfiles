-- Override config from nvim-lspconfig
vim.lsp.config("twiggy_language_server", {
  cmd = { vim.fn.expand("~/lsp/bin/twiggy-language-server"), "--stdio" }
})
