-- Override config from nvim-lspconfig
vim.lsp.config("sqlls", {
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
