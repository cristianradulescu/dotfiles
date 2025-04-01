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
    config = function()
      vim.g.rest_nvim = {
        request = {
          hooks = {
            user_agent = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36",
          },
        },
        clients = {
          curl = {
            statistics = {
              { id = "time_total", winbar = "take", title = "Time taken" },
              { id = "time_connect", title = "Connect time" },
              { id = "size_download", title = "Download size" },
              { id = "speed_download", title = "Download speed" },
              { id = "size_upload", title = "Upload size" },
              { id = "speed_upload", title = "Upload speed" },
              { id = "local_ip", title = "Local IP" },
              { id = "local_port", title = "Local port" },
              { id = "remote_ip", title = "Remote IP" },
              { id = "remote_port", title = "Remote port" },
              { id = "exitcode", title = "Exit code" },
              { id = "errormsg", title = "Error message" },
            },
          },
        },
      }
    end,
  },
}
