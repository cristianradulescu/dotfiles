return {
  {
    -- Auto add the "paired" character when typing the first one (", {, [...)
    "echasnovski/mini.pairs",
    -- stable version
    version = "*",
    config = function()
      require("mini.pairs").setup()
    end
  },
  {
    -- More text objects selections
    "echasnovski/mini.ai",
    version = "*",
    config = function()
      require("mini.ai").setup()
    end
  },
  {
    -- Manage surround charaters
    "echasnovski/mini.surround",
    version = "*",
    config = function()
      require("mini.surround").setup()
    end
  },
  {
    -- Show bubffers as tabs
    "echasnovski/mini.tabline",
    version = "*",
    config = function()
      require("mini.tabline").setup()
    end
  },
}
