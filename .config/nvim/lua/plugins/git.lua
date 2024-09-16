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
        current_line_blame_formatter = "<committer> <committer_mail>, <author_time:%Y-%m-%d %H:%M> - <summary>",
        on_attach = function(buffnr)
          vim.keymap.set("n", "<leader>ghp", require("gitsigns").preview_hunk,
            { buffer = buffnr, desc = "Git hunk preview" })
          vim.keymap.set("n", "<leader>ghr", require("gitsigns").reset_hunk, { buffer = buffnr, desc = "Hunk reset" })
          vim.keymap.set("n", "<leader>ghR", require("gitsigns").reset_buffer,
            { buffer = buffnr, desc = "Hunk buffer reset" })
          vim.keymap.set("n", "<leader>ghs", require("gitsigns").stage_hunk, { buffer = buffnr, desc = "Hunk stage" })
          vim.keymap.set("n", "<leader>ghus", require("gitsigns").undo_stage_hunk,
            { buffer = buffnr, desc = "Hunk undo stage" })
          vim.keymap.set("n", "<leader>gbl", require("gitsigns").blame_line, { desc = "Git blame line" })
          vim.keymap.set("n", "<leader>gbh", require("gitsigns").toggle_current_line_blame,
            { desc = "Git blame line hints" })

          vim.keymap.set({ "n", "v" }, "]c", function()
            if vim.wo.diff then return "]c" end
            vim.schedule(function() require("gitsigns").next_hunk() end)
            return "<Ignore>"
          end, { expr = true, buffer = buffnr, desc = "Next hunk" })
          vim.keymap.set({ "n", "v" }, "[c", function()
            if vim.wo.diff then return "[c" end
            vim.schedule(function() require("gitsigns").prev_hunk() end)
            return "<Ignore>"
          end, { expr = true, buffer = buffnr, desc = "Previous hunk" })
        end
      })
    end
  },

  vim.keymap.set("n", "<leader>gbf", "<cmd>Git blame<CR>", { desc = "Git blame file" }),
  vim.keymap.set("n", "<leader>gdf", "<cmd>DiffviewFileHistory --no-merges %<cr>", { desc = "Git file history" })
}

