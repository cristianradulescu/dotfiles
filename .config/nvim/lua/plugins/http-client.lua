return {
  -- {
  --   "mistweaverco/kulala.nvim",
  --   opts = {
  --     default_view = "headers_body",
  --     additional_curl_options = {
  --       -- User agent
  --       "-A",
  --       "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36 Edg/133.0.0.0",
  --       -- /User agent
  --     },
  --     -- debug = true,
  --   },
  --
  --   config = function(_, opts)
  --     require("kulala").setup(opts)
  --
  --     vim.keymap.set({ "n" }, "<leader>hkr", function()
  --       return require("kulala").run()
  --     end, { desc = "HTTP request - Run" })
  --
  --     vim.keymap.set({ "n" }, "<leader>hke", function()
  --       return require("kulala").set_selected_env()
  --     end, { desc = "HTTP Request - Select ENV" })
  --   end,
  -- },

  {
    "cristianradulescu/rest.nvim",
    branch = "view-request-headers",
    keys = {
      {
        "<leader>hr",
        "<cmd>Rest run<cr>",
        mode = "n",
        desc = "HTTP Request - Run",
      },
      {
        "<leader>he",
        "<cmd>Rest env select<cr>",
        mode = "n",
        desc = "HTTP Request - Select ENV",
      },
    },
  }
}
