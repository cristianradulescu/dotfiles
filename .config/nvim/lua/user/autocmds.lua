-- ============================================================================
-- IndentDetect — per-buffer indentation detection
-- Runs after each file is read. Scans the first 32 lines for leading
-- whitespace to determine whether the file uses tabs or spaces, and (for
-- spaces) what the indent width is. All settings are applied buffer-locally
-- so they don't affect the global defaults set in options.lua.
-- ============================================================================
local indent_detect_group = vim.api.nvim_create_augroup("IndentDetect", { clear = true })
vim.api.nvim_create_autocmd("BufReadPost", {
  group = indent_detect_group,
  desc = "Auto-detect indentation (tabs vs spaces, indent width)",
  callback = function(event)
    local buf = event.buf

    -- Only run on normal file buffers; skip terminals, quickfix, help, etc.
    local bt = vim.bo[buf].buftype
    if bt ~= "" then
      return
    end

    local lines = vim.api.nvim_buf_get_lines(buf, 0, 32, false)

    local has_tabs = false
    local space_counts = {}  -- leading-space lengths from each indented line

    for _, line in ipairs(lines) do
      -- A tab anywhere in the leading whitespace → treat the file as tab-indented
      local leading = line:match("^(\t+)")
      if leading then
        has_tabs = true
        break
      end

      -- Collect the length of leading spaces on this line
      local spaces = line:match("^( +)")
      if spaces then
        space_counts[#space_counts + 1] = #spaces
      end
    end

    if has_tabs then
      -- Tab-indented file: disable expandtab and let shiftwidth=0 defer to tabstop
      vim.bo[buf].expandtab = false
      vim.bo[buf].shiftwidth = 0  -- 0 means "use tabstop value"
      return
    end

    -- Not enough data to decide — keep the global defaults from options.lua
    if #space_counts == 0 then
      return
    end

    -- The GCD of all leading-space counts gives the fundamental indent unit.
    -- e.g. counts {2,4,6} → GCD = 2 (2-space indent)
    --      counts {4,8,12} → GCD = 4 (4-space indent)
    local function gcd(a, b)
      while b ~= 0 do
        a, b = b, a % b
      end
      return a
    end

    local indent_width = space_counts[1]
    for i = 2, #space_counts do
      indent_width = gcd(indent_width, space_counts[i])
      if indent_width == 1 then
        break  -- GCD can't go below 1; stop early
      end
    end

    -- A GCD of 1 usually means mixed or non-standard indentation; ignore it
    -- and keep the global defaults rather than setting shiftwidth=1.
    if indent_width < 2 then
      return
    end
    -- Cap at 8 to guard against pathological files with huge indent widths
    indent_width = math.min(indent_width, 8)

    vim.bo[buf].expandtab    = true
    vim.bo[buf].shiftwidth   = indent_width
    vim.bo[buf].tabstop      = indent_width
    vim.bo[buf].softtabstop  = indent_width
  end,
})

-- ============================================================================
-- NoDiag — suppress diagnostics for specific file patterns
-- Avoids noise from:
--   - .env files: the shell/bash LSP flags undefined variables everywhere
--   - vendor/ trees: third-party code that shouldn't be touched
-- ============================================================================
local no_diag_group = vim.api.nvim_create_augroup("NoDiag", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  desc = "Disable diagnostics for specific files",
  pattern = { ".env", ".env.*", "*/vendor/*" },
  callback = function(event)
    vim.diagnostic.enable(false, { bufnr = event.buf })
  end,
  group = no_diag_group,
})

-- ============================================================================
-- YankHighlight — briefly flash yanked text
-- Uses Neovim's built-in highlight helper; no extra dependencies needed.
-- See `:help vim.highlight.on_yank()`
-- ============================================================================
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  group = highlight_group,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- ============================================================================
-- ResizeSplits — equalise split sizes when the terminal window is resized
-- Iterates over all tabs so every split in every tab is rebalanced, then
-- returns to whichever tab was active before.
-- ============================================================================
local resize_group = vim.api.nvim_create_augroup("ResizeSplits", { clear = true })
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = resize_group,
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- ============================================================================
-- LastLoc — restore cursor to its last known position when reopening a file
-- The position is stored in the " mark by Neovim automatically. Skips
-- gitcommit buffers because the cursor should always start at line 1 there.
-- ============================================================================
local last_loc_group = vim.api.nvim_create_augroup("LastLoc", { clear = true })
vim.api.nvim_create_autocmd("BufReadPost", {
  group = last_loc_group,
  callback = function(event)
    local buf = event.buf
    local exclude = { "gitcommit" }

    -- Guard against running twice on the same buffer
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true

    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    -- Only jump if the saved mark is within the current file length
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- ============================================================================
-- SimpleSession — lightweight per-directory session management
-- Session files are saved to <cwd>/.nvim/session.vim so each project has
-- its own session. The session is restored automatically when Neovim is
-- opened in the same directory with no explicit file arguments.
-- The saved items are controlled by vim.opt.sessionoptions in options.lua.
-- ============================================================================
local session_group = vim.api.nvim_create_augroup("SimpleSession", { clear = true })

vim.api.nvim_create_autocmd("VimLeavePre", {
  group = session_group,
  desc = "Save session on exit",
  callback = function()
    local session_dir  = vim.fn.getcwd() .. "/.nvim"
    local session_file = session_dir .. "/session.vim"

    if vim.fn.isdirectory(session_dir) == 0 then
      vim.fn.mkdir(session_dir, "p")
    end

    local ok, err = pcall(vim.cmd, "mksession! " .. vim.fn.fnameescape(session_file))
    if not ok then
      vim.notify("Failed to save session: " .. tostring(err), vim.log.levels.ERROR)
    end
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  group = session_group,
  desc = "Restore session on start",
  nested = true,  -- allow other autocmds (e.g. LSP attach) to fire during source
  callback = function()
    local session_file = vim.fn.getcwd() .. "/.nvim/session.vim"

    -- Don't restore if files were passed on the command line (e.g. `nvim foo.lua`)
    if vim.fn.argc() == 0 and vim.fn.filereadable(session_file) == 1 then
      local ok, err = pcall(vim.cmd, "source " .. vim.fn.fnameescape(session_file))
      if not ok then
        vim.notify("Failed to load session: " .. tostring(err), vim.log.levels.WARN)
      end
    end
  end,
})

-- ============================================================================
-- CloseWithQ — map `q` to close ephemeral/read-only windows
-- Many UI windows (help, quickfix, fugitive, etc.) don't need a full :quit
-- workflow. This makes pressing `q` close them and delete the buffer cleanly.
-- ============================================================================
local close_with_q = vim.api.nvim_create_augroup("CloseWithQ", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = close_with_q,
  pattern = {
    "checkhealth",
    "fugitive",
    "fugitiveblame",
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
    -- vim.schedule defers keymap creation until after the buffer is fully
    -- initialised, avoiding race conditions with filetype plugins.
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

-- ============================================================================
-- FixJsonConceal — keep JSON files readable
-- Neovim's default conceallevel hides quotes around JSON keys/values, which
-- makes files hard to edit. Force it to 0 for all JSON variants.
-- ============================================================================
local fix_json_conceal = vim.api.nvim_create_augroup("FixJsonConceal", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = fix_json_conceal,
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- ============================================================================
-- Terminal — quality-of-life tweaks for the built-in terminal
-- ============================================================================

-- Enter insert mode immediately when focusing a terminal buffer so keystrokes
-- are sent to the shell rather than treated as Normal-mode commands.
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "term://*",
  callback = function()
    vim.cmd("startinsert")
  end,
})

-- Hide line numbers and the sign column in terminal buffers; they have no
-- meaning there and just take up horizontal space.
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.opt_local.number         = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn     = "no"
  end,
})
