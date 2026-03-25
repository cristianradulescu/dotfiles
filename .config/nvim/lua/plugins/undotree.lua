-- undotree — visual branching undo history
-- Neovim's undo history is a tree (not a linear stack), so multiple undo
-- branches can exist after different edits. undotree makes this visible and
-- navigable. Particularly useful after accidentally overwriting a change and
-- needing to recover a branch that :undo can no longer reach.
--
-- The panel opens on the left (SplitWidth = 30) and steals focus immediately
-- so keyboard navigation works without an extra step.
--
-- Keymap:
--   <leader>U   toggle the undotree panel
return {
  "mbbill/undotree",
  config = function()
    vim.g.undotree_SetFocusWhenToggle = 1  -- focus the panel on open
    vim.g.undotree_SplitWidth         = 30 -- panel width in columns

    vim.keymap.set("n", "<leader>U", vim.cmd.UndotreeToggle, { desc = "Toggle Undotree" })
  end,
}
