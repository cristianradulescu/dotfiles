return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "php" })
      end
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = false,
    opts = {
      formatters_by_ft = {
        php = {
          "php_cs_fixer",
        },
      },
      formatters = {
        php_cs_fixer = function()
          local conform_util = require("conform.util")
          return {
            command = conform_util.find_executable({
              -- search in project root
              "php-cs-fixer",
              "php-cs-fixer.phar",
              -- search in bi from project root
              "bin/php-cs-fixer",
              "bin/php-cs-fixer.phar",
              --search in vendor/bin
              "vendor/bin/php-cs-fixer",
              "vendor/bin/php-cs-fixer.phar",
            }, "php-cs-fixer"),
          }
        end,
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- phpactor = {
        --   cmd = {
        --     "env",
        --     "XDEBUG_SESSION=1",
        --     "php",
        --     "/home/cristian/.local/share/nvim/mason/packages/phpactor/bin/phpactor",
        --     "language-server",
        --   },
        -- },
      },
    },
  },
}
