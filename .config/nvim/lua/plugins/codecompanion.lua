-- codecompanion.nvim — AI chat and inline editing inside Neovim
--
-- Both the chat window and the inline assistant use the GitHub Copilot
-- adapter backed by Claude Sonnet by default.
--
-- Additional adapters (Gemini, Ollama) are registered but not set as default;
-- switch to them inside a chat session with the adapter picker.
--
-- Chat history is persisted across sessions via the codecompanion-history
-- extension so previous conversations are reachable from the chat window.
return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim", -- async utilities
    "nvim-treesitter/nvim-treesitter", -- used for code block parsing in chat
    "ravitemer/codecompanion-history.nvim",
  },
  config = function()
    require("codecompanion").setup({
      strategies = {
        -- Chat window strategy (opened with <leader>at)
        chat = {
          adapter = {
            name = "copilot",
            model = "claude-sonnet-4.5",
          },
        },
        -- Inline assistant strategy (edits code in-place)
        inline = {
          adapter = {
            name = "copilot",
            model = "claude-sonnet-4.5",
          },
        },
      },

      adapters = {
        http = {
          -- Gemini: API key read from $GEMINI_API_KEY env var or ~/.codecompanion/gemini file
          gemini = function()
            return require("codecompanion.adapters").extend("gemini", {
              env = {
                api_key = os.getenv("GEMINI_API_KEY") or vim.fn.readfile(vim.fn.expand("~/.codecompanion/gemini"))[1],
              },
            })
          end,

          -- Ollama: local instance expected at http://127.0.0.1:11434
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

      extensions = {
        -- Persist chat sessions to disk so they survive Neovim restarts
        history = { enabled = true },
      },
    })
  end,

  keys = {
    { "<leader>at", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle CodeCompanion chat" },
    -- Add the visual selection to the current chat window as a code block
    { "<leader>aa", "<cmd>CodeCompanionChat Add<cr>", desc = "Add to CodeCompanion chat", mode = "x" },
  },

  -- Lazy-load on explicit command invocation as well
  cmd = { "CodeCompanion" },
}
