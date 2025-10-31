-- Override config from nvim-lspconfig
vim.lsp.config("lua_ls", {
  cmd = { "php", vim.fn.expand("~/lsp/bin/phpactor"), "laguage-server" },
})

return {}
