-- Colorscheme — catppuccin (mocha flavour)
-- Loaded with priority = 1000 so it is applied before all other plugins,
-- preventing a flash of the default colorscheme on startup.
-- Transparent background lets the terminal's own background show through.
return {
  {
    "catppuccin/nvim",
    name     = "catppuccin",
    priority = 1000,
    config   = function()
      require("catppuccin").setup({
        transparent_background = true,
      })
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },
}
