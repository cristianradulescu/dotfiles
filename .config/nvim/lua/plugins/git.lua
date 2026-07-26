-- Git tooling — four complementary plugins:
--
--   vim-fugitive   full Git UI (:Git, :Git blame, push/pull/rebase, etc.)
--   diffview.nvim  side-by-side diff viewer and per-file commit history timeline
--   gitsigns.nvim  gutter signs for added/changed/deleted lines, inline blame,
--                  and hunk-level staging/resetting
--   mergetool      three-way merge conflict resolution
--                  (github.com/cristianradulescu/mergetool) — aligned
--                  ours/result/theirs panes instead of raw conflict markers
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
--
--   Mergetool (global):
--     <leader>gm    resolve the current file's conflict (reads base/ours/theirs
--                   from the git index — the file must actually be unmerged);
--                   opens a new tab with three panes. Inside that tab:
--                     ]c / [c   jump to the next / previous conflict
--                     co / ct   accept ours / theirs for the conflict at the cursor
--                     :w        save — stages the file (git add) once resolved
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

  -- Three-way merge conflict resolution. Rust core + native mlua module, so
  -- it needs a `cargo build` after install/update; lazy.nvim's `build` hook
  -- runs that in the plugin's own directory automatically. The plugin's Lua
  -- loader then finds target/release (or target/debug) there on its own.
  --
  -- NOTE: this table must come before the bare `vim.keymap.set(...)` calls
  -- below. Those calls return nil, which — sitting bare in this array
  -- literal — leaves nil holes partway through the table; `ipairs` (which
  -- lazy.nvim's spec loader uses to walk this returned list) stops at the
  -- first nil, so anything appended *after* those calls is invisible to
  -- lazy.nvim even though it's still a real, addressable table entry.
  {
    "cristianradulescu/mergetool",
    build = "cargo build --workspace --release",
    keys = {
      {
        "<leader>gm",
        function()
          local path = vim.fn.expand("%:p")
          local cwd = vim.fn.expand("%:p:h")
          local ok, err = pcall(require("mergetool.resolve").resolve, path, cwd)
          if not ok then
            vim.notify("mergetool: " .. tostring(err), vim.log.levels.ERROR)
          end
        end,
        desc = "Resolve merge conflict (mergetool)",
      },
    },
  },

  -- Diffview keymaps registered globally (not buffer-local) because diffview
  -- windows are not normal file buffers.
  vim.keymap.set({ "n", "v" }, "<leader>gdf", "<cmd>DiffviewFileHistory --no-merges %<cr>", { desc = "Git file/selection history" }),
  vim.keymap.set("n",          "<leader>gdo", "<cmd>DiffviewOpen<cr>",                      { desc = "Diffview open" }),
  vim.keymap.set("n",          "<leader>gdc", "<cmd>DiffviewClose<cr>",                     { desc = "Diffview close" }),
}
