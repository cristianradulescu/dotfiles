-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Set filetype for environment specific dotenv files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  desc = "Set filetype for .env.local",
  pattern = ".env.*",
  command = "set filetype=sh",
})
