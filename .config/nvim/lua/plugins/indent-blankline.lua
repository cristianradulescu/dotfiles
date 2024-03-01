return {
  {
    -- Add indentation guides even on blank lines
    "lukas-reineke/indent-blankline.nvim",
    event = "BufEnter",
    main = "ibl",
    opts = {},
    config = function()
      require("ibl").setup({
        indent = {
          char = '┆',
        }
      })
    end
  }
}
