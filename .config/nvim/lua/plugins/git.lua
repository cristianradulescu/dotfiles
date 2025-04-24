return {
  -- Git managment
  { "tpope/vim-fugitive" },

  -- Git diff / file history
  { "sindrets/diffview.nvim" },

  {
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
        },
        current_line_blame_formatter = "<author> <author_mail>, <author_time:%Y-%m-%d %H:%M> - <summary>",
        on_attach = function(buffnr)
          vim.keymap.set("n", "<leader>ghp", require("gitsigns").preview_hunk,
            { buffer = buffnr, desc = "Git hunk preview" })
          vim.keymap.set("n", "<leader>ghr", require("gitsigns").reset_hunk, { buffer = buffnr, desc = "Hunk reset" })
          vim.keymap.set("n", "<leader>ghR", require("gitsigns").reset_buffer,
            { buffer = buffnr, desc = "Hunk buffer reset" })
          vim.keymap.set("n", "<leader>ghs", require("gitsigns").stage_hunk, { buffer = buffnr, desc = "Hunk stage/unstage" })
          vim.keymap.set("n", "<leader>gbl", require("gitsigns").blame_line, { desc = "Git blame line" })
          vim.keymap.set("n", "<leader>gbh", require("gitsigns").toggle_current_line_blame,
            { desc = "Git blame line hints" })

          vim.keymap.set({ "n", "v" }, "]c", function()
            if vim.wo.diff then return "]c" end
            vim.schedule(function() require("gitsigns").nav_hunk('next') end)
            return "<Ignore>"
          end, { expr = true, buffer = buffnr, desc = "Next hunk" })
          vim.keymap.set({ "n", "v" }, "[c", function()
            if vim.wo.diff then return "[c" end
            vim.schedule(function() require("gitsigns").nav_hunk('prev') end)
            return "<Ignore>"
          end, { expr = true, buffer = buffnr, desc = "Previous hunk" })
        end
      })
    end
  },

  vim.keymap.set("n", "<leader>gbf", "<cmd>Git blame<CR>", { desc = "Git blame file" }),
  vim.keymap.set("n", "<leader>gdf", "<cmd>DiffviewFileHistory --no-merges %<cr>", { desc = "Git file history" }),
  vim.keymap.set("n", "<leader>gdo", "<cmd>DiffviewOpen<cr>", { desc = "Diffview open" }),
  vim.keymap.set("n", "<leader>gdc", "<cmd>DiffviewClose<cr>", { desc = "Diffview close" })
}

