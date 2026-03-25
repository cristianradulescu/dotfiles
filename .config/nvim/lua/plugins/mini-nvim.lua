-- mini.nvim — collection of small, focused Neovim plugins
-- Only the four modules used here are loaded; the rest of mini.nvim is not
-- installed.
return {
  {
    -- mini.ai — extended text objects
    -- Adds `around` and `inner` selections for brackets, quotes, function
    -- arguments, and more. Examples: vaf (function), diq (inner quotes),
    -- cia (change inner argument).
    "nvim-mini/mini.ai",
    version = "*",
    config = function()
      require("mini.ai").setup()
    end,
  },

  {
    -- mini.surround — add, change, and delete surrounding characters
    -- sa{motion}{char}  add surrounding
    -- sd{char}          delete surrounding
    -- sr{old}{new}      replace surrounding
    "nvim-mini/mini.surround",
    version = "*",
    config = function()
      require("mini.surround").setup()
    end,
  },

  {
    -- mini.icons — extended icon set
    -- Supplements nvim-web-devicons with additional file-type and UI icons
    -- used by neo-tree, bufferline, lualine, and blink-cmp.
    "nvim-mini/mini.icons",
    version = "*",
    config = function()
      require("mini.icons").setup()
    end,
  },

  {
    -- mini.notify — notification UI with LSP progress support
    -- Replaces vim.notify with a floating window that stacks messages and
    -- auto-dismisses them. Also shows LSP indexing/loading progress with a
    -- configurable duration for the final "done" message.
    "nvim-mini/mini.notify",
    version = "*",
    config = function()
      require("mini.notify").setup({
        lsp_progress = {
          -- Keep the "done" message visible for 5 s so it's readable before
          -- it fades out.
          duration_last = 5000,
        },
      })
    end,
  },

  -- mini.indentscope — visual guide for indent levels
  -- Draws a vertical line at the start of each indent level.
  {
    "nvim-mini/mini.indentscope",
    version = "*",
    config = function()
      require("mini.indentscope").setup()
    end,
  },
}
