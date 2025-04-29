local http_client = {
  user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36 Edg/133.0.0.0",
  keymap_desc = {
    run = "HTTP Client - Run",
    env = "HTTP Client - Select ENV",
    copy_as_curl = "HTTP Client - Copy as CURL",
  },
}

return {
  {
    "mistweaverco/kulala.nvim",
    cond = function()
      return vim.g.http_client == "Kulala"
    end,
    ft = "http",
    opts = {
      default_view = "headers_body",
      additional_curl_options = {
        -- Set user agent / doesn't work, needs to be set in request
        "-A",
        http_client.user_agent,
      },
    },

    config = function(_, opts)
      local kulala = require("kulala")
      kulala.setup(opts)

      vim.keymap.set({ "n" }, "<leader>hr", function()
        return kulala.run()
      end, { desc = http_client.keymap_desc.run })

      vim.keymap.set({ "n" }, "<leader>he", function()
        return kulala.set_selected_env()
      end, { desc = http_client.keymap_desc.env })

      vim.keymap.set({ "n" }, "<leader>hc", function()
        return kulala.copy()
      end, { desc = http_client.keymap_desc.copy_as_curl })
    end,
  },

  {
    "cristianradulescu/rest.nvim",
    branch = "view-request-headers",
    enabled = function()
      return vim.g.http_client == "Rest"
    end,
    config = function()
      vim.keymap.set({ "n" }, "<leader>hr", "<cmd>Rest run<cr>", { desc = http_client.keymap_desc.run })
      vim.keymap.set({ "n" }, "<leader>he", "<cmd>Rest env select<cr>", { desc = http_client.keymap_desc.env })

      vim.g.rest_nvim = {
        request = {
          hooks = {
            user_agent = http_client.user_agent,
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
