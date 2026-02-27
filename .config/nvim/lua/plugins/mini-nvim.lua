return {
  {
    -- More text objects selections
    "nvim-mini/mini.ai",
    version = "*",
    config = function()
      require("mini.ai").setup()
    end,
  },
  {
    -- Manage surround characters
    "nvim-mini/mini.surround",
    version = "*",
    config = function()
      require("mini.surround").setup()
    end,
  },
  {
    -- Extra icons
    "nvim-mini/mini.icons",
    version = "*",
    config = function()
      require("mini.icons").setup()
    end,
  },
  {
    -- Extra icons
    "nvim-mini/mini.notify",
    version = "*",
    config = function()
      require("mini.notify").setup({
        -- Notifications about LSP progress
        lsp_progress = {
          -- Duration (in ms) of how long last message should be shown
          duration_last = 5000,
        },
      })
    end,
  },
}
