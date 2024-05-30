return {
  -- Code formatting
  "stevearc/conform.nvim",
  opts = {},
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        sql = { "sqlfmt" },
        mysql = { "sqlfmt" },
        lua = { "luaformatter" }
      },
    })
  end,
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = "",
      desc = "Format code (with Conform)"
    }
  }
}
