-- lualine.nvim — statusline
-- Layout (left → right):
--   lualine_a  mode (single letter: N / I / V / …)
--   lualine_b  cwd (abbreviated) · filetype icon · relative filename
--   lualine_c  (empty)
--   lualine_x  diagnostics · git diff · filetype · position · encoding ·
--              line-ending format · indent style (spaces/tabs) · branch
--
-- The cwd component intelligently shortens the path:
--   - Replaces /home/<user> with ~
--   - If the full path is ≤ 30 chars, shows every segment abbreviated to
--     3 characters except the final (current) directory which is shown in full
--   - If longer, shows only the immediate parent directory name
--
-- Statusline is hidden for neo-tree windows (they have their own header bar).
-- Extensions are enabled for fugitive, lazy, quickfix, and nvim-dap-ui so
-- those windows get a context-appropriate statusline instead of the default.
return {
  "nvim-lualine/lualine.nvim",
  event        = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config       = function()
    require("lualine").setup({
      options = {
        -- No separator characters between components or sections
        component_separators = "",
        section_separators   = "",
        -- Hide the statusline in neo-tree (it has its own winbar)
        disabled_filetypes   = { statusline = { "neo-tree" } },
      },

      sections = {
        -- Section A: current mode, abbreviated to a single letter
        lualine_a = {
          {
            "mode",
            fmt = function(str) return str:sub(1, 1) end,
          },
        },

        -- Section B: cwd + filetype icon + filename
        lualine_b = {
          {
            -- Custom CWD component
            function()
              local current_path = vim.loop.cwd() or ""

              -- Shorten the path to just the parent directory name when the
              -- full path is long, to avoid overflowing the statusline.
              local function parent_only()
                local parts = vim.fn.split(current_path, "/")
                return " " .. vim.fn.slice(parts, vim.fn.len(parts) - 1)[1]
              end

              -- Show all segments abbreviated to 3 chars, except the last.
              -- Replace /home/<user> with ~ first.
              local function full_path()
                local p = vim.fn.substitute(current_path, "\\/home\\/\\w*", "~", "")
                local parts     = vim.fn.split(p, "/")
                local new_parts = {}
                for i, v in pairs(parts) do
                  new_parts[i] = (i < vim.fn.len(parts)) and vim.fn.slice(v, 0, 3) or v
                end
                return " " .. vim.fn.join(new_parts, "/")
              end

              return vim.fn.len(current_path) > 30 and parent_only() or full_path()
            end,
            separator = "",
            padding   = { right = 1, left = 1 },
            -- Inherit the foreground colour from the Normal highlight group so
            -- the component blends with the colourscheme automatically.
            color     = require("user.functions").fg("Normal"),
          },
          {
            "filename",
            path    = 1,  -- show path relative to cwd
            padding = { right = 0, left = 0 },
          },
        },

        lualine_c = {},

        -- Section X: diagnostics, git diff, and file metadata
        lualine_x = {
          { "diagnostics" },
          {
            -- Git diff stats sourced from gitsigns so the numbers stay in sync
            -- with the gutter signs without a separate git process.
            "diff",
            source = function()
              local gs = vim.b.gitsigns_status_dict
              if gs then
                return { added = gs.added, modified = gs.changed, removed = gs.removed }
              end
            end,
          },
          { "filetype" },
          { "location", padding = { left = 0, right = 1 } },
          { "encoding" },
          {
            -- Normalised line-ending format label (LF / CRLF)
            "fileformat",
            symbols = { unix = "LF", dos = "CRLF" },
          },
          {
            -- Show the effective indent style for the current buffer so it is
            -- always clear whether the file uses spaces or tabs, and how wide.
            function()
              if vim.api.nvim_buf_get_option(0, "expandtab") then
                return vim.api.nvim_buf_get_option(0, "shiftwidth") .. " spc"
              end
              return "tabs"
            end,
          },
          {
            "branch", fmt = function(str)
              local max_length = 17
              return #str > max_length and str:sub(1, max_length) .. "..." or str
            end
          },
        },

        lualine_y = {},
        lualine_z = {},
      },

      extensions = { "fugitive", "lazy", "quickfix", "nvim-dap-ui" },
    })
  end,
}
