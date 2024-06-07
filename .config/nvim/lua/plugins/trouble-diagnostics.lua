return {
  -- Diagnostic messages
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {},
  vim.keymap.set("n", "<leader>q", "<cmd>Trouble diagnostics toggle filter.buf=0 focus=true", { desc = "Open diagnostics" }),
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" }),
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" }),
}
