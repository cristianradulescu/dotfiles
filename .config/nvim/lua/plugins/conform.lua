return {
  -- Code formatting
  "stevearc/conform.nvim",
  event = "BufReadPost",
  opts = {},
  config = function()
    require("conform").setup({
      formatters = {
        sqlfluff = {
          args = { "format", "--dialect=mysql", "-" },
          -- disable require_cwd so that a config file is not required
          require_cwd = false,
        },
      },
      formatters_by_ft = {
        lua = { "stylua" },
        sql = { "sqlfluff" },
        twig = { "djlint" },
        json = { "jq" },
      },
    })
  end,
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ async = false, lsp_fallback = true, quiet = false })
      end,
      mode = "",
      desc = "Format code (with Conform)",
    },
  },
}
