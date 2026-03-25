-- Treesitter — syntax parsing, highlighting, and navigation
-- Two plugins work together here:
--
--   nvim-treesitter              parser management, highlighting, indentation,
--                                incremental selection, and text objects
--   nvim-treesitter-context      sticky context line at the top of the window
--                                showing the function/class the cursor is inside
--
-- Parsers guaranteed to be installed: php, json, bash, lua, markdown,
-- markdown_inline. All other parsers are installed automatically the first
-- time a file of that type is opened (auto_install = true).
--
-- Text object keymaps (visual / operator-pending):
--   aa / ia   around / inner function argument
--   af / if   around / inner function
--   ac / ic   around / inner class
--
-- Incremental selection:
--   <C-Space>   start / expand selection to the next node
--   <C-s>       expand selection to the enclosing scope
--   <M-Space>   shrink selection by one node
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    dependencies = {
      -- Text objects require the textobjects module from this sub-plugin
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    -- Re-compile changed parsers after a plugin update
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        -- Parsers that are always installed
        ensure_installed = { "php", "json", "bash", "lua", "markdown", "markdown_inline" },
        sync_install     = true,
        ignore_install   = {},
        modules          = {},

        -- Automatically install a parser the first time a new filetype is opened
        auto_install = true,

        highlight = { enable = true },

        -- Use treesitter for indentation (replaces the built-in indent rules)
        indent = { enable = true },

        incremental_selection = {
          enable  = true,
          keymaps = {
            init_selection    = "<C-space>",
            node_incremental  = "<C-space>",
            scope_incremental = "<C-s>",
            node_decremental  = "<M-space>",
          },
        },

        textobjects = {
          select = {
            enable    = true,
            -- Jump forward to the next text object if the cursor is not inside one
            lookahead = true,
            keymaps = {
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
          move = {
            enable     = true,
            set_jumps  = true,  -- add movements to the jumplist so <C-o>/<C-i> work
          },
        },
      })
    end,
  },

  {
    -- Show the current function/class/block at the top of the window when the
    -- definition is scrolled out of view. Capped at 1 line to avoid obscuring
    -- code with multi-line signatures.
    "nvim-treesitter/nvim-treesitter-context",
    opts = {
      max_lines = 1,
    },
  },
}
