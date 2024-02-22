return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    version = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim"
    },
    init = function()
      -- autostart Neotree when Neovim starts in a directory
      if vim.fn.argc() == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require("neo-tree")
        end
      end
    end,
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    config = function()
      require("neo-tree").setup({
        sources = { "filesystem", "git_status", "buffers" },
        open_files_do_not_replace_types = { "terminal", "Trouble" },
        filesystem = {
          filtered_items = {
            visible = true,
            show_hidden_count = true,
            hide_dotfiles = false,
          },
          bind_to_cwd = true,
          follow_curent_file = { enabled = true },
          use_libuv_file_watcher = true,
        },
        source_selector = {
          winbar = true,
          statusline = false,
        },
        default_component_configs = {
          indent = {
            with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
            expander_collapsed = "+",
            expander_expanded = "",
            expander_highlight = "NeoTreeExpander",
          },
        },
        window = {
          -- do nothing when <space> is pressed while neo-tree is focused
          mappings = {
            ["<space>"] = "none"
          }
        },
      })
    end
  }
}
