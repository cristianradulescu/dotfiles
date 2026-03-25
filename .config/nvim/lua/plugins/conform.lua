-- conform.nvim — formatter dispatcher
-- Runs external formatters per filetype and falls back to the LSP formatter
-- when no dedicated tool is configured (lsp_fallback = true in the keymap).
-- vim.opt.formatexpr is pointed at conform in options.lua so that `gq` also
-- uses it.
--
-- Formatters used:
--   lua  → stylua
--   sql  → sqlfluff (MySQL dialect, config file not required)
--   twig → djlint
--   json → jq
return {
  "stevearc/conform.nvim",
  event = "BufReadPost",
  config = function()
    require("conform").setup({
      formatters = {
        -- Override sqlfluff defaults: target MySQL and allow running without
        -- a project-level .sqlfluff config file.
        sqlfluff = {
          args        = { "format", "--dialect=mysql", "-" },
          require_cwd = false,
        },
      },

      formatters_by_ft = {
        lua  = function() return { "stylua" } end,
        sql  = function() return { "sqlfluff" } end,
        twig = function() return { "djlint" } end,
        json = function() return { "jq" } end,
        -- php = function() return { "php_cs_fixer" } end,
      },
    })
  end,

  keys = {
    {
      "<leader>cf",
      function()
        -- async = false: block until formatting completes before returning
        -- lsp_fallback = true: use the LSP formatter when no conform formatter matches
        require("conform").format({ async = false, lsp_fallback = true, quiet = false })
      end,
      mode = "",
      desc = "Format code (with Conform)",
    },
  },
}
