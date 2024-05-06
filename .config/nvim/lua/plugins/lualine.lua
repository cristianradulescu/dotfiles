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
          -- disabled_filetypes = { statusline = { "neo-tree" } },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = {
            {
              function()
                local current_path = vim.loop.cwd() or ""
                current_path = vim.fn.substitute(current_path, "\\/home\\/\\w*", "~", "")
                return " " .. current_path
              end,
              separator = "/",
              padding = { right = 0, left = 1 },
              color = require("user.functions").fg("Normal"),
            },
            {
              "filename",
              path = 1,
              padding = { right = 0, left = 0 }
            },
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
            { "location",   padding = { left = 0, right = 1 } },
          },
          lualine_y = {
            { "branch" },
          },
          lualine_z = {
          },
        },
        extensions = { "neo-tree", "fugitive", "lazy", "mason", "quickfix", "trouble" }
      })
    end
  },
}
