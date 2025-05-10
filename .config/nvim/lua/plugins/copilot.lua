return {
  -- {
  --   "zbirenbaum/copilot.lua",
  --   cond = function()
  --     return vim.g.copilot_enabled
  --   end,
  --   config = function()
  --     require("copilot").setup()
  --   end,
  --   cmd = "Copilot",
  --   event = "InsertEnter",
  --   opts = {
  --     suggestion = {
  --       enable = true,
  --       panel = { enabled = true },
  --     },
  --   },
  -- },
  {
    "github/copilot.vim",
    cond = function()
      return vim.g.copilot_enabled
    end,
  },
}
