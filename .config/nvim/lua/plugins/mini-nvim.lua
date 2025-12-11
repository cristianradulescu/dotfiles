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
  -- {
  --   -- Auto add matching pair
  --   "nvim-mini/mini.pairs",
  --   version = "*",
  --   config = function()
  --     require("mini.pairs").setup()
  --   end,
  -- },
}
