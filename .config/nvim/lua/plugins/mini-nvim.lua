return {
  -- {
  --   -- More text objects selections
  --   "echasnovski/mini.ai",
  --   version = "*",
  --   config = function()
  --     require("mini.ai").setup()
  --   end
  -- },
  {
    -- Manage surround charaters
    "echasnovski/mini.surround",
    version = "*",
    config = function()
      require("mini.surround").setup()
    end,
  },
  {
    "echasnovski/mini.sessions",
    version = "*",
    config = function()
      require("mini.sessions").setup({
        autostart = true,
      })
    end,
  },
}
