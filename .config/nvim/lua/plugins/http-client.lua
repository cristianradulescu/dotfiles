-- kulala.nvim — HTTP request runner for *.http files
-- Works like VS Code REST Client or JetBrains HTTP Client: write requests
-- directly in a .http file and execute them without leaving Neovim.
-- Only loaded for http filetypes (see ftdetect/http.lua).
--
-- Keymaps (normal mode, prefix <leader>h):
--   hr   run the request under the cursor
--   hR   run all requests in the file sequentially
--   he   select the active environment (e.g. dev / staging / prod)
--   hc   copy the current request as a curl command
--   hi   import a curl command and convert it to .http syntax
local http_client = {
  -- Default User-Agent sent with requests when not overridden per-request.
  -- Note: the -A flag in additional_curl_options below doesn't work reliably;
  -- set the User-Agent header inline in the .http file instead.
  user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36 Edg/133.0.0.0",
}

return {
  {
    "mistweaverco/kulala.nvim",
    ft   = "http",
    opts = {
      -- Show both response headers and body by default
      default_view = "headers_body",
      additional_curl_options = {
        "-A", http_client.user_agent,
      },
      ui = {
        -- Don't redirect large responses to a temp file; show everything inline
        max_response_size = 999999999,
      },
    },
    config = function(_, opts)
      local kulala = require("kulala")
      kulala.setup(opts)

      vim.keymap.set("n", "<leader>hr", function() kulala.run() end,              { desc = "HTTP Client - Run" })
      vim.keymap.set("n", "<leader>hR", function() kulala.run_all() end,          { desc = "HTTP Client - Run all" })
      vim.keymap.set("n", "<leader>he", function() kulala.set_selected_env() end, { desc = "HTTP Client - Select ENV" })
      vim.keymap.set("n", "<leader>hc", function() kulala.copy() end,             { desc = "HTTP Client - Copy as CURL" })
      vim.keymap.set("n", "<leader>hi", function() kulala.from_curl() end,        { desc = "HTTP Client - Import from CURL" })
    end,
  },
}
