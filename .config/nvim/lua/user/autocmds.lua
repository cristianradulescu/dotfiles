-- Set filetype for environment specific dotenv files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  desc = "Set filetype for .env.* files",
  pattern = ".env.*",
  command = "set filetype=sh",
})

-- Highlight on yank. See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Resize splits if window got resized
local resize_group = vim.api.nvim_create_augroup("ResizeSplits", { clear = true })
vim.api.nvim_create_autocmd({ "VimResized" }, {
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
  group = resize_group,
})
