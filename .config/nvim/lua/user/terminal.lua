-- terminal.lua — quality-of-life tweaks, keymaps, and helpers for the
-- built-in terminal.
--
-- Keymap reference:
--   <leader>th   open a horizontal terminal split
--   <leader>tv   open a vertical terminal split
--   <leader>tt   open a terminal in a new tab
--   <leader>tf   open a terminal in a bordered floating window
--   <Esc>        exit terminal insert mode (maps to <C-\><C-n>)
--   <C-h/j/k/l>  move focus between splits (terminal mode, exits insert first)

-- ============================================================================
-- Autocmds
-- ============================================================================

-- Enter insert mode immediately when focusing a terminal buffer so keystrokes
-- are sent to the shell rather than treated as Normal-mode commands.
-- Also jump to the last line first: without it, entering insert mode while
-- the shell is still writing its prompt leaves the cursor stranded wherever
-- it happened to be (often line 1) instead of following the prompt down.
local function terminal_enter_insert()
  -- Pickers such as fzf-lua (vim.ui.select) run in a terminal buffer and
  -- already enter terminal mode; :normal cannot run from there.
  if vim.fn.mode():sub(1, 1) == "t" then
    return
  end
  vim.cmd("normal! G")
  vim.cmd.startinsert()
end

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "term://*",
  callback = terminal_enter_insert,
})

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "term://*",
  callback = function()
    vim.schedule(terminal_enter_insert)
  end,
})

-- Hide line numbers and the sign column in terminal buffers; they have no
-- meaning there and just take up horizontal space.
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.opt_local.spell = false
  end,
})

-- ============================================================================
-- Keymaps
-- ============================================================================

-- Exit terminal insert mode with <Esc> instead of the default <C-\><C-n>,
-- which is awkward to type.
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Navigate from terminal mode to other splits without needing to exit insert
-- mode first — each mapping exits terminal mode then moves to the split.
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Terminal: go to left window" })
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Terminal: go to lower window" })
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Terminal: go to upper window" })
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Terminal: go to right window" })

-- Open terminals in different layouts
vim.keymap.set("n", "<leader>th", ":split | terminal<CR>",  { desc = "Terminal in horizontal split" })
vim.keymap.set("n", "<leader>tv", ":vsplit | terminal<CR>", { desc = "Terminal in vertical split" })
vim.keymap.set("n", "<leader>tt", ":tabnew | terminal<CR>", { desc = "Terminal in new tab" })

-- Regular splits can't have a border (only floating windows can), so this
-- opens the terminal in a centered floating window with a rounded border
-- instead. The window closes itself once the shell process exits.
local function open_floating_terminal()
  local width  = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)

  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width    = width,
    height   = height,
    row      = math.floor((vim.o.lines - height) / 2),
    col      = math.floor((vim.o.columns - width) / 2),
    style    = "minimal",
    border   = "rounded",
  })

  vim.fn.termopen(vim.o.shell)

  vim.api.nvim_create_autocmd("TermClose", {
    buffer = buf,
    once = true,
    callback = function()
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
    end,
  })
end

vim.keymap.set("n", "<leader>tf", open_floating_terminal, { desc = "Terminal in floating window" })
