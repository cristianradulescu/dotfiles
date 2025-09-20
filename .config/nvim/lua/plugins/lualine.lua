return {
  -- Bottom info bar
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("lualine").setup({
      options = {
        component_separators = "",
        section_separators = "",
        disabled_filetypes = { statusline = { "neo-tree" } },
      },
      sections = {
        lualine_a = {
          {
            "mode",
            fmt = function(str)
              return str:sub(1, 1)
            end,
          },
        },
        -- Curent dir
        lualine_b = {
          {
            function()
              local current_path = vim.loop.cwd() or ""

              -- Show full path of the current dir
              local function full_path()
                -- If on home dir, use ~
                current_path = vim.fn.substitute(current_path, "\\/home\\/\\w*", "~", "")

                -- Keep only the first 3 chars of each dir except for the parent
                local new_path = {}
                local path_parts = vim.fn.split(current_path, "/")
                for key, value in pairs(path_parts) do
                  if key < vim.fn.len(path_parts) then
                    new_path[key] = vim.fn.slice(value, 0, 3)
                  else
                    new_path[key] = value
                  end
                end

                return " " .. vim.fn.join(new_path, "/")
              end

              -- Show only the parent dir
              local function parent_only()
                local path_parts = vim.fn.split(current_path, "/")
                return " " .. vim.fn.slice(path_parts, vim.fn.len(path_parts) - 1)[1]
              end

              if vim.fn.len(current_path) > 30 then
                return parent_only()
              end

              return full_path()
            end,
            separator = "",
            padding = { right = 1, left = 1 },
            color = require("user.functions").fg("Normal"),
          },
          {
            "filetype",
            icon_only = true,
            separator = "",
            padding = { right = 0, left = 1 },
          },
          {
            "filename",
            path = 1,
            padding = { right = 0, left = 0 },
          },
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
          { "filetype" },
          { "location", padding = { left = 0, right = 1 } },
          { "encoding" },
          {
            "fileformat",
            symbols = {
              unix = "LF",
              dos = "CRLF",
            },
          },
          {
            -- Use tabs or spaces
            function()
              local use_spaces = vim.api.nvim_buf_get_option(0, "expandtab")

              if use_spaces then
                return vim.api.nvim_buf_get_option(0, "shiftwidth") .. " spaces"
              end

              return "tabs"
            end,
          },
          { "branch" },
        },
        lualine_y = {},
        lualine_z = {},
      },
      extensions = { "fugitive", "lazy",  "quickfix", "nvim-dap-ui" },
    })
  end,
}
