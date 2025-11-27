-- Override config from nvim-lspconfig
vim.lsp.config("sqlls", {
  cmd = { vim.fn.expand("~/lsp/bin/sql-language-server"), "up", "--method", "stdio" },
  settings = {
    sqlLanguageServer = {
      lint = {
        rules = {
          reservedWordCase = "off",
        }
      }
    }
  },
})

return {}
