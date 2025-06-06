return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  cond = function()
    return vim.g.copilot_enabled
  end,
  init = function()
    require("plugins.codecompanion.fidget-spinner"):init()
  end,
  config = function()
    require("codecompanion").setup({
      strategies = {
        chat = {
          adapter = "copilot",
        },
        inline = {
          adapter = "copilot",
        },
      },
      adapters = {
        gemini = function()
          return require("codecompanion.adapters").extend("gemini", {
            env = {
              api_key = os.getenv("GEMINI_API_KEY") or vim.fn.readfile(vim.fn.expand("~/.codecompanion/gemini"))[1],
            },
          })
        end,
      },
    })
  end,
  keys = {
    { "<leader>at", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle CodeCompanion chat" },
    { "<leader>aa", "<cmd>CodeCompanionChat Add<cr>", desc = "Add to CodeCompanion chat", mode = "x" },
  },
}
