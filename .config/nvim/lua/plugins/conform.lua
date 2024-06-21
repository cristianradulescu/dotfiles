return {
  -- Code formattin
  "stevearc/conform.nvim",
  event = "BufReadPost",
  opts = {},
  config = function()
    ---Check if the formatter is found for current buffer and install it if missing using Mason.
    ---Mason may use a different name for formatters, in that case the mason_pkg_name needs to be provided.
    ---@param formatter_name string
    ---@param mason_pkg_name? string
    local function ensure_installed(formatter_name, mason_pkg_name)
      if not mason_pkg_name then
        mason_pkg_name = formatter_name
      end

      if false == require("conform").get_formatter_info(formatter_name).available then
        vim.cmd("MasonInstall " .. mason_pkg_name)
      end
    end

    require("conform").setup({
      formatters_by_ft = {
        lua = function()
          ensure_installed("stylua")
          return { "stylua" }
        end,

        php = function()
          ensure_installed("php_cs_fixer", "php-cs-fixer")
          return { "php_cs_fixer" }
        end,

        sql = function()
          ensure_installed("sqlfmt")
          return { "sqlfmt" }
        end,

        mysql = function()
          ensure_installed("sqlfmt")
          return { "sqlfmt" }
        end,
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
      desc = "Format code (with Conform)",
    },
  },
}
