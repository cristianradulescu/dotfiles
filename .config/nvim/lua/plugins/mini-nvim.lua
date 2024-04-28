return {
  {
    -- Auto add the "paried" character when typing the first one (", {, [...) 
    "echasnovski/mini.pairs",
    -- stable version
    version = "*",
    config = function ()
      require("mini.pairs").setup()
    end
  },
}
