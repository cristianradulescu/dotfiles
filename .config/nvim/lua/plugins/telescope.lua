return {
  -- Fuzzy Finder (files, lsp, etc)
  {
    "nvim-telescope/telescope.nvim",
    version = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = "make",
        cond = function()
          return vim.fn.executable "make" == 1
        end,
      },
    },

    config = function()
      require("telescope").setup({
        defaults = {
          layout_strategy = "vertical",
          layout_config = {
            vertical = {
              mirror = true,
              prompt_position = "top",
            },
          },
          mappings = {
            i = {
              ["<C-u>"] = false,
              ["<C-d>"] = false,
            },
          },
          -- Search in non-vcs and hidden files (--no-ignore-vcs, --hidden)
          vimgrep_arguments = { "rg", "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case", "--no-ignore-vcs", "--hidden" }
        }
      })
      pcall(require("telescope").load_extension, "fzf")
    end
  },

}
