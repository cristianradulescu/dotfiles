return {
  -- File explorer
  "nvim-neo-tree/neo-tree.nvim",
  version = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim"
  },
  deactivate = function()
    vim.cmd([[Neotree close]])
  end,

  config = function()
    require("neo-tree").setup({
      sources = { "filesystem" },
      filesystem = {
        filtered_items = {
          visible = true,
          show_hidden_count = true,
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        bind_to_cwd = true,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
      },
      source_selector = {
        winbar = true,
        statusline = false,
      },
      default_component_configs = {
        indent = {
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
        },
      },
    })
  end,
  keys = {
    {
      "<leader>e",
      function()
        require("neo-tree.command").execute({ toggle = true, reveal = true, dir = vim.loop.cwd() })
      end,
      mode = "n",
      desc = "File explorer"
    }
  }
}
