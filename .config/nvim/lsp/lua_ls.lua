-- Override config from nvim-lspconfig
vim.lsp.config("lua_ls", {
  -- cmd = { vim.fn.expand("~/lsp/bin/lua-language-server") },
  settings = {
    Lua = {
      workspace = {
        checkThirdParty = true,
        library = {
          vim.env.VIMRUNTIME,
        },
      },
      telemetry = { enabled = false },
      format = { enable = false },
    },
  },
})

return {}
