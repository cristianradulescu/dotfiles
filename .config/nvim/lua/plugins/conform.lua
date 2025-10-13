return {
  -- Code formattin
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
        lua = function()
          return { "stylua" }
        end,

        sql = function()
          return { "sqlfluff" }
        end,

        twig = function()
          return { "djlint" }
        end,

        json = function()
          return { "jq" }
        end,

        -- php = function()
        --   return { "php_cs_fixer" }
        -- end,
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
