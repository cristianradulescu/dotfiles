vim.lsp.config("intelephense", {
  settings = {
    intelephense = {
      files = {
        maxSize = 99000000, -- 99MB?
      },
    },
  },
})

return {}
