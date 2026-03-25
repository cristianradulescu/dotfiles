-- Git tooling — three complementary plugins:
--
--   vim-fugitive   full Git UI (:Git, :Git blame, push/pull/rebase, etc.)
--   diffview.nvim  side-by-side diff viewer and per-file commit history timeline
--   gitsigns.nvim  gutter signs for added/changed/deleted lines, inline blame,
--                  and hunk-level staging/resetting
--
-- Keymaps:
--   Fugitive / Diffview (global):
--     <leader>gdf   file history for the current file or selection (no merge commits)
--     <leader>gdo   open Diffview (staged + unstaged changes)
--     <leader>gdc   close Diffview
--
--   Gitsigns (buffer-local, set in on_attach):
--     <leader>gbf   full file blame (opens gitsigns blame window)
--     <leader>gbl   blame annotation for the current line
--     <leader>gbh   toggle inline blame hints on every line
--     <leader>ghp   preview the hunk under the cursor in a floating window
--     <leader>ghr   reset the hunk under the cursor to its HEAD state
--     <leader>ghR   reset the entire buffer to its HEAD state
--     <leader>ghs   stage / unstage the hunk under the cursor
--     ]c / [c       jump to the next / previous hunk (works in diff mode too)
return {
  -- Full-featured Git UI; use :Git <command> for anything not keybound
  { "tpope/vim-fugitive" },

  -- Side-by-side diffs and file history browser
  { "sindrets/diffview.nvim" },

  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        -- Gutter sign characters for each change type
        signs = {
          add          = { text = "+" },
          change       = { text = "~" },
          delete       = { text = "_" },
          topdelete    = { text = "‾" },
          changedelete = { text = "~" },
        },

        -- Format for the inline blame annotation shown by blame_line / toggle_current_line_blame
        current_line_blame_formatter = "<author> <author_mail>, <author_time:%Y-%m-%d %H:%M> - <summary>",

        on_attach = function(bufnr)
          local gs = require("gitsigns")

          -- Blame
          vim.keymap.set("n", "<leader>gbf", gs.blame,                       { buffer = bufnr, desc = "Git blame file" })
          vim.keymap.set("n", "<leader>gbl", gs.blame_line,                  { buffer = bufnr, desc = "Git blame line" })
          vim.keymap.set("n", "<leader>gbh", gs.toggle_current_line_blame,   { buffer = bufnr, desc = "Git blame line hints" })

          -- Hunk operations
          vim.keymap.set("n", "<leader>ghp", gs.preview_hunk,                { buffer = bufnr, desc = "Git hunk preview" })
          vim.keymap.set("n", "<leader>ghr", gs.reset_hunk,                  { buffer = bufnr, desc = "Git hunk reset" })
          vim.keymap.set("n", "<leader>ghR", gs.reset_buffer,                { buffer = bufnr, desc = "Git buffer reset" })
          vim.keymap.set("n", "<leader>ghs", gs.stage_hunk,                  { buffer = bufnr, desc = "Git hunk stage/unstage" })

          -- Hunk navigation: fall back to built-in ]c/[c when already in diff mode
          vim.keymap.set({ "n", "v" }, "]c", function()
            if vim.wo.diff then return "]c" end
            vim.schedule(function() gs.nav_hunk("next") end)
            return "<Ignore>"
          end, { expr = true, buffer = bufnr, desc = "Next hunk" })

          vim.keymap.set({ "n", "v" }, "[c", function()
            if vim.wo.diff then return "[c" end
            vim.schedule(function() gs.nav_hunk("prev") end)
            return "<Ignore>"
          end, { expr = true, buffer = bufnr, desc = "Previous hunk" })
        end,
      })
    end,
  },

  -- Diffview keymaps registered globally (not buffer-local) because diffview
  -- windows are not normal file buffers.
  vim.keymap.set({ "n", "v" }, "<leader>gdf", "<cmd>DiffviewFileHistory --no-merges %<cr>", { desc = "Git file/selection history" }),
  vim.keymap.set("n",          "<leader>gdo", "<cmd>DiffviewOpen<cr>",                      { desc = "Diffview open" }),
  vim.keymap.set("n",          "<leader>gdc", "<cmd>DiffviewClose<cr>",                     { desc = "Diffview close" }),
}
