return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  init = function()
    require("plugins.codecompanion.fidget-spinner"):init()
  end,
  config = function()
    require("codecompanion").setup({
      strategies = {
        chat = {
          adapter = "gemini",
        },
        inline = {
          adapter = "gemini",
        },
      },
      adapters = {
        http = {
          gemini = function()
            return require("codecompanion.adapters").extend("gemini", {
              env = {
                api_key = os.getenv("GEMINI_API_KEY") or vim.fn.readfile(vim.fn.expand("~/.codecompanion/gemini"))[1],
              },
            })
          end,
          ollama = function()
            return require("codecompanion.adapters").extend("ollama", {
              env = {
                url = "http://127.0.0.1:11434",
              },
              headers = {
                ["Content-Type"] = "application/json",
              },
              parameters = {
                sync = true,
              },
            })
          end,
        },
      },
    })
  end,
  keys = {
    { "<leader>at", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle CodeCompanion chat" },
    { "<leader>aa", "<cmd>CodeCompanionChat Add<cr>", desc = "Add to CodeCompanion chat", mode = "x" },
  },
}
