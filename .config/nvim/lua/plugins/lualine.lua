return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          component_separators = "⎟",
          section_separators = "",
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = {
            {
              function()
                local current_path = vim.loop.cwd() or ""
                return vim.fn.substitute(current_path, "\\/home\\/\\w*", "~", "")
              end,
              separator = "",
            },
            { "filename", path = 1, padding = { right = 0, left = 0 }, color = M.fg("Keyword") },
          },
          lualine_c = {
          },
          lualine_x = {
            { "diagnostics" },
            {
              "diff",
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
            },
            { "encoding" },
            { "fileformat" },
            { "filetype" },
          },
          lualine_y = {
            { "progress", separator = " ", padding = { left = 1, right = 0 } },
            { "location", padding = { left = 0, right = 1 } },
          },
          lualine_z = {
            { "branch" },
          },
        },
      })
    end
  },
}
