return {
  "stevearc/overseer.nvim",
  ---@module "overseer"
  ---@type overseer.SetupOpts
  opts = {},
  keys = {
    {
      "<leader>ot",
      "<cmd>OverseerToggle<cr>",
      desc = "Overseer: Toggle",
    },
    {
      "<leader>or",
      "<cmd>OverseerRun<cr>",
      desc = "Overseer: Run Task",
    },
  },
}
