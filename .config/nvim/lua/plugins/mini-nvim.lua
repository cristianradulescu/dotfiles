return {
  {
    -- More text objects selections
    "echasnovski/mini.ai",
    version = "*",
    config = function()
      require("mini.ai").setup()
    end,
  },
  {
    -- Manage surround characters
    "echasnovski/mini.surround",
    version = "*",
    config = function()
      require("mini.surround").setup()
    end,
  },
  {
    -- Extra icons
    "echasnovski/mini.icons",
    version = "*",
    config = function()
      require("mini.icons").setup()
    end,
  },
  {
    -- Auto add matching pair
    "echasnovski/mini.pairs",
    version = "*",
    config = function()
      require("mini.pairs").setup()
    end,
  },
}
