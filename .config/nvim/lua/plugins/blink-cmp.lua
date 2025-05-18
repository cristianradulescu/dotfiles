return {
  "saghen/blink.cmp",
  dependencies = { "rafamadriz/friendly-snippets" },
  version = "1.*",
  config = function()
    require("blink.cmp").setup()
    vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities(nil, true) })
  end,
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    fuzzy = { implementation = "lua" },
    completion = {
      list = {
        max_items = 20,
      },
      documentation = { auto_show = true, auto_show_delay_ms = 500 },
      menu = { auto_show = false }
    },
  }
}
