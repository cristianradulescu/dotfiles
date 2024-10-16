-- ---------------------------------------------------------------
-- EXPERIMENTS
-- Things that I might not use in the future, but are fun to build
-- ---------------------------------------------------------------

-- -------
-- KEYMAPS
-- -------

-- [PHP] add semicolon at the end of line
vim.keymap.set("i", "<A-;>", function()
  local buffnr = vim.api.nvim_get_current_buf()

  if vim.bo[buffnr].filetype == "php" then
    return "<esc><cmd>TSTextobjectGotoNextEnd @statement.outer<cr>A;"
  end

  return "<Ignore>"
end, { expr = true, desc = "Add endline semicolon for PHP files" })


-- ---------
-- FUNCTIONS
-- ---------
-- local M = {}
-- return M
