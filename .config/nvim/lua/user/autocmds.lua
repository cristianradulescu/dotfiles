-- Disable diagnostics:
-- - useless bash script diagnostics for env files
-- - external packages
local no_diag_group = vim.api.nvim_create_augroup("NoDiag", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  desc = "Disable diagnostics for specific files",
  pattern = { ".env", ".env.*", "*/vendor/*" },
  callback = function(event)
    local buf = event.buf
    vim.diagnostic.enable(false, { bufnr = buf })
  end,
  group = no_diag_group,
})

-- Highlight on yank. See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
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

-- go to last loc when opening a buffer
local last_loc_group = vim.api.nvim_create_augroup("LastLoc", { clear = true })
vim.api.nvim_create_autocmd("BufReadPost", {
  group = last_loc_group,
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- PHP debugging with containers is buggy with nvim-dap, use VSCode instead
vim.api.nvim_create_user_command(
  "OpenProjectInVSCode",
  -- open VSCode in a new window and add current project dir
  "!code -n -a " .. vim.uv.cwd(),
  { desc = "Open project in VSCode" }
)

-- when vim closes, save the session
vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
  desc = "Save session on exit",
  callback = function()
    require("persistence").save()
  end,
})

vim.api.nvim_create_autocmd({ "VimEnter" }, {
  desc = "Load session on start",
  -- enable nested to prevent file type not being set issues when session is restored
  -- https://github.com/echasnovski/mini.nvim/issues/1133#issuecomment-2282721563
  nested = true,
  callback = function()
    if vim.fn.expand("%:t") == "" then
      require("persistence").load()
    end
  end,
})

local close_with_q = vim.api.nvim_create_augroup("CloseWithQ", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = close_with_q,
  pattern = {
    "checkhealth",
    "gitsigns-blame",
    "help",
    "lspinfo",
    "neotest-output",
    "neotest-output-panel",
    "neotest-summary",
    "notify",
    "qf",
    "startuptime",
    "tsplayground",
    "fugitive",
    "fugitiveblame",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
      })
    end)
  end,
})

-- Fix conceallevel for json files
local fix_json_conceal = vim.api.nvim_create_augroup("FixJsonConceal", { clear = true })
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = fix_json_conceal,
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})
