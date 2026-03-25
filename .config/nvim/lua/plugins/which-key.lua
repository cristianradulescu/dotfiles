-- which-key.nvim — keymap hint popup
-- After the leader key (or any partial key sequence) is pressed and held for
-- timeoutlen milliseconds, a floating window appears listing all continuations.
-- Useful for discovering keymaps without checking the config.
--
-- timeoutlen is also set globally in options.lua; the duplicate assignment
-- here ensures which-key has the right value even if options.lua load order
-- ever changes.
return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init  = function()
      vim.o.timeout    = true
      vim.o.timeoutlen = 300
    end,
    opts = {},
  },
}
