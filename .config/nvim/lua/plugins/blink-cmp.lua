return {
  "saghen/blink.cmp",
  cond = function()
    return vim.g.cmp_engine == "blink"
  end,
  dependencies = { "rafamadriz/friendly-snippets" },
  version = "1.*",
  config = function(_, opts)
    require("blink.cmp").setup(opts)
    vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities(nil, true) })
  end,
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    fuzzy = { implementation = "lua" },
    completion = {
      list = {
        -- Do not insert items while browsing the autocomplete menu
        selection = { preselect = true, auto_insert = false },
        -- max_items = 10,
      },
      documentation = {
        auto_show = true,
      },
      menu = {
        auto_show = function()
          return vim.g.copilot_enabled
        end,
      },
    },
    cmdline = { enabled = false },
  },
}
