return {
  -- DISABLED: requires deno and some lib tweaks
  -- {
  --   "toppair/peek.nvim",
  --   event = { "VeryLazy" },
  --   build = "deno task --quiet build:fast",
  --   config = function()
  --     require("peek").setup({
  --       theme = "light",
  --     })
  --
  --     vim.api.nvim_create_user_command("MarkdownPeekOpen", require("peek").open, {})
  --     vim.api.nvim_create_user_command("MarkdownPeekClose", require("peek").close, {})
  --   end,
  -- },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {},
  },
}
