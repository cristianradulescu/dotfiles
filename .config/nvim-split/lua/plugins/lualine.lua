return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
          options = {
            icons_enabled = true,
            theme = 'auto',
            component_separators = '|',
            section_separators = '',
            -- do not show it for Neotree (or use extensions)
            -- disabled_filetypes = { statusline = { 'neo-tree' } }
          },
          extensions = { 'neo-tree', 'lazy' },
          sections = {
            lualine_c = {
              { 'filetype', icon_only = true, separator = "", padding = { left = 1, right = 0 } },
              { 'filename', path = 1 },
            },
          },
      })
    end
  },
}
