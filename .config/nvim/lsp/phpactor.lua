-- Override config from nvim-lspconfig
vim.lsp.config("phpactor", {
  cmd = { "php", vim.fn.expand("~/lsp/bin/phpactor"), "language-server" },
})

return {}
