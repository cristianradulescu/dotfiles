return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- event = "BufEnter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    build = ":TSUpdate",
    config = function()
      -- See `:help nvim-treesitter`
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "php",
          "python",
          "json",
          "bash",
          "html",
          "css",
          "javascript",
          "typescript",
          "lua",
          "markdown",
          "markdown_inline",
          "sql",
        },
        sync_install = true,
        ignore_install = {},
        modules = {},

        -- Autoinstall languages that are not installed.
        auto_install = true,

        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<c-space>",
            node_incremental = "<c-space>",
            scope_incremental = "<c-s>",
            node_decremental = "<M-space>",
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
          },
        },
      })
    end,
  },

  -- Show the context of the currently visible buffer contents
  {
    "nvim-treesitter/nvim-treesitter-context",
    opts = {
      -- Window should span at max 1 line to prevent clutter from multiline definitions
      max_lines = 1,
    },
  },
}
