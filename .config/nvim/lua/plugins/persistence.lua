return {
  "folke/persistence.nvim",
  event = "BufReadPre", -- this will only start a session when an actual file was opened
  opts = {},
  vim.keymap.set("n", "<leader>ws", function ()
    require("persistence").load()
  end, { desc = "Load session for current dir" }),
  vim.keymap.set("n", "<leader>Ws", function ()
    require("persistence").select()
  end, { desc = "Select session" }),
}
