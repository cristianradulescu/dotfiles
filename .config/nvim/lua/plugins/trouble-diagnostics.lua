return {
  -- Diagnostic messages
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {},
  vim.keymap.set("n", "<leader>q", "<cmd>Trouble diagnostics toggle filter.buf=0 focus=true<cr>", { desc = "Open diagnostics" }),
}
