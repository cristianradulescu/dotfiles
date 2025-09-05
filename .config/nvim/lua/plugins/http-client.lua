local http_client = {
  user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36 Edg/133.0.0.0",
  keymap_desc = {
    run = "HTTP Client - Run",
    run_all = "HTTP Client - Run all",
    env = "HTTP Client - Select ENV",
    copy_as_curl = "HTTP Client - Copy as CURL",
    import_from_curl = "HTTP Client - Import from CURL",
  },
}

return {
  {
    "mistweaverco/kulala.nvim",
    ft = "http",
    opts = {
      default_view = "headers_body",
      additional_curl_options = {
        -- Set user agent / doesn't work, needs to be set in request
        "-A",
        http_client.user_agent,
      },
      ui = {
        -- Do not redirect large responses to files
        max_response_size = 999999999
      }
    },

    config = function(_, opts)
      local kulala = require("kulala")
      kulala.setup(opts)

      vim.keymap.set({ "n" }, "<leader>hr", function()
        return kulala.run()
      end, { desc = http_client.keymap_desc.run })

      vim.keymap.set({ "n" }, "<leader>hR", function()
        return kulala.run_all()
      end, { desc = http_client.keymap_desc.run_all })

      vim.keymap.set({ "n" }, "<leader>he", function()
        return kulala.set_selected_env()
      end, { desc = http_client.keymap_desc.env })

      vim.keymap.set({ "n" }, "<leader>hc", function()
        return kulala.copy()
      end, { desc = http_client.keymap_desc.copy_as_curl })

      vim.keymap.set({ "n" }, "<leader>hi", function()
        return kulala.from_curl()
      end, { desc = http_client.keymap_desc.import_from_curl })
    end,
  }
}
