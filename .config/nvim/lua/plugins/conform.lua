-- conform.nvim — formatter dispatcher
-- Runs external formatters per filetype and falls back to the LSP formatter
-- when no dedicated tool is configured (lsp_fallback = true in the keymap).
-- vim.opt.formatexpr is pointed at conform in options.lua so that `gq` also
-- uses it.
--
-- Formatters used:
--   lua  → stylua
--   sql  → sqlfluff (MySQL dialect; the local fork adds SHOW statement
--          support, installed via `pipx install --editable ~/Development/sqlfluff`)
--   twig → djlint
--   json → jq
-- Hardcoded fallback .sqlfluff, used when a project doesn't provide its own.
local fallback_sqlfluff_config = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h") .. "/conform/.sqlfluff"

return {
  "stevearc/conform.nvim",
  event = "BufReadPost",
  config = function()
    require("conform").setup({
      formatters = {
        -- Override sqlfluff defaults: use the project's own .sqlfluff if one is
        -- found upward from the buffer, else fall back to a hardcoded config,
        -- and allow running without a project-level .sqlfluff config file.
        sqlfluff = {
          args = function(_, ctx)
            local project_config = vim.fs.find(".sqlfluff", { upward = true, path = ctx.dirname })[1]
            return { "format", "--config", project_config or fallback_sqlfluff_config, "-" }
          end,
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
        -- timeout_ms: conform's sync path defaults to 1000ms, too tight for
        -- some formatters' cold start; only the value passed here applies
        -- (a per-formatter timeout_ms config has no effect on the sync path).
        require("conform").format({ async = false, lsp_fallback = true, quiet = false, timeout_ms = 10000 })
      end,
      mode = "",
      desc = "Format code (with Conform)",
    },
  },
}
