-- Set filetype for environment specific dotenv files
-- Use `bash` as type to prevent diagnostics
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  desc = "Set filetype for .env.* files",
  pattern = { ".env", ".env.*" },
  command = "set filetype=bash",
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
  { desc = "Format current buffer with LSP" }
)

-- when vim closes, save the session
vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
  desc = "Save session on exit",
  callback = function()
    MiniSessions.write("Session.vim")
  end,
})

vim.api.nvim_create_autocmd({ "VimEnter" }, {
  desc = "Load session on start",
  -- enable nested to prevent file type not being set issues when session is restored
  -- https://github.com/echasnovski/mini.nvim/issues/1133#issuecomment-2282721563
  nested = true,
  callback = function()
    if vim.fn.expand("%:t") == "" then
      MiniSessions.read("Session.vim")
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
