-- local Util = require("lazyvim.util")

return {
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        component_separators = "⎟",
        section_separators = "",
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {
          -- {
          --   function()
          --     local current_path = vim.loop.cwd()
          --     current_path = vim.fn.substitute(current_path, "\\/home\\/cristian", "~", "")
          --     return "󱉭  " .. current_path
          --   end,
          --   color = Util.ui.fg("Special"),
          -- },
          { "filetype", icon_only = true, separator = "", padding = { right = 0, left = 1 } },
          { "filename", path = 3 },
        },
        lualine_c = {},
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
          { "branch" },
        },
        lualine_y = {
          { "encoding" },
          { "fileformat" },
          { "filetype" },
        },
        lualine_z = {
          { "progress", separator = " ", padding = { left = 1, right = 0 } },
          { "location", padding = { left = 0, right = 1 } },
        },
      },
    },
  },
}
