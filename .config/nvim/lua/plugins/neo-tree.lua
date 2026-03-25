-- neo-tree.nvim — tree-style file explorer
-- Active when vim.g.fileexplorer == "NeoTree" (set in options.lua).
-- The alternative explorer is Snacks (see snacks.lua.disabled).
--
-- Notable configuration choices:
--   - Only the "filesystem" source is enabled (no buffers/git-status tabs)
--   - Dotfiles and gitignored files are shown (hidden_count badge instead)
--   - The tree follows the active file automatically (follow_current_file)
--   - libuv file watcher keeps the tree in sync without manual refresh
--   - The source selector is shown in the winbar, not the statusline
--
-- Keymap:
--   <leader>e   toggle neo-tree (reveal the current file if already open)
return {
  "nvim-neo-tree/neo-tree.nvim",
  version = "v3.x",
  cond    = function()
    return vim.g.fileexplorer == "NeoTree"
  end,
  dependencies = {
    "nvim-lua/plenary.nvim",       -- async utilities
    "nvim-tree/nvim-web-devicons", -- file-type icons
    "MunifTanjim/nui.nvim",        -- UI component library (popups, splits)
  },
  -- Close the tree when this plugin is deactivated (e.g. switching to Snacks)
  deactivate = function()
    vim.cmd("Neotree close")
  end,
  config = function()
    require("neo-tree").setup({
      -- Only enable the filesystem source; buffer and git-status panels are not used.
      sources = { "filesystem" },

      filesystem = {
        filtered_items = {
          visible          = true,   -- show filtered items with a dimmed style
          show_hidden_count = true,  -- badge with count of hidden items
          hide_dotfiles    = false,  -- show dotfiles (e.g. .env, .gitignore)
          hide_gitignored  = false,  -- show gitignored files
        },
        bind_to_cwd          = true,              -- root follows vim's cwd
        follow_current_file  = { enabled = true },-- scroll to the active file
        use_libuv_file_watcher = true,            -- auto-refresh on fs changes
      },

      source_selector = {
        winbar    = true,   -- show source tabs in the winbar
        statusline = false,
      },

      default_component_configs = {
        indent = {
          -- Show expand/collapse arrows for nested entries
          with_expanders = true,
        },
      },
    })
  end,

  keys = {
    {
      "<leader>e",
      function()
        require("neo-tree.command").execute({ toggle = true, reveal = true, dir = vim.uv.cwd() })
      end,
      mode = "n",
      desc = "File explorer",
    },
  },
}
