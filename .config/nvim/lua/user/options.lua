-- ============================================================================
-- Leader keys
-- Must be set before plugins are loaded, otherwise the wrong leader is used.
-- ============================================================================
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ============================================================================
-- Feature flags
-- These globals act as switches for interchangeable plugin implementations.
-- They are read by plugin specs and keymaps to activate the selected backend.
-- ============================================================================

-- Enable/disable GitHub Copilot inline suggestions (requires copilot.lua)
vim.g.copilot_enabled = false

-- Fuzzy finder backend. Options: "FzfLua", "Snacks"
vim.g.picker = "FzfLua"

-- File explorer backend. Options: "NeoTree", "Snacks"
vim.g.fileexplorer = "NeoTree"

-- Active PHP LSP server(s). Options: "intelephense", "phpactor"
-- Multiple servers can be enabled at once, e.g. {"intelephense", "phpactor"}
vim.g.php_lsp = { "intelephense" }

-- ============================================================================
-- UI
-- ============================================================================

vim.opt.background = "dark"

-- Rounded borders on all floating windows (requires Neovim 0.11+)
vim.opt.winborder = "rounded"

-- Don't highlight all search matches after searching; just jump to them
vim.opt.hlsearch = false

vim.wo.number = true           -- Show absolute line number on the current line
vim.opt.relativenumber = true  -- Show relative numbers on all other lines
vim.opt.cursorline = true      -- Highlight the line the cursor is on
vim.opt.scrolloff = 8          -- Keep at least 8 lines visible above/below the cursor
vim.opt.sidescrolloff = 8      -- Keep at least 8 columns visible left/right of the cursor
vim.opt.colorcolumn = "120"    -- Vertical ruler at column 120 (soft line-length limit)

-- Don't show --INSERT-- / --VISUAL-- etc.; the statusline already shows the mode
vim.opt.showmode = false

-- Enable mouse support in all modes (useful for resizing splits)
vim.opt.mouse = "a"

-- Use 24-bit colour. Requires a terminal that supports truecolour.
vim.opt.termguicolors = true

-- ============================================================================
-- Clipboard
-- Sync the unnamed register with the system clipboard so that yanking in
-- Neovim makes text available to other applications and vice versa.
-- Remove this if you want the two clipboards to stay independent.
-- See `:help "clipboard"`
-- ============================================================================
vim.opt.clipboard = "unnamedplus"

-- ============================================================================
-- Indentation (global defaults)
-- Per-buffer values are overridden at open-time by the IndentDetect autocmd
-- in autocmds.lua, which detects the actual indentation style used in each file.
-- ============================================================================

vim.opt.smartindent = true   -- Auto-insert indent after {, after if/for/while, etc.
vim.opt.expandtab = true     -- Use spaces instead of a literal tab character
vim.opt.shiftwidth = 2       -- Spaces per indent level (used by >> / << and smartindent)
vim.opt.shiftround = true    -- Always indent to a multiple of shiftwidth
vim.opt.tabstop = 2          -- How wide a \t character looks on screen
vim.opt.softtabstop = 2      -- How many spaces <Tab>/<BS> insert/remove in insert mode

-- ============================================================================
-- Whitespace display
-- ============================================================================

vim.opt.wrap = false  -- Don't wrap long lines; scroll horizontally instead
vim.opt.list = true   -- Render non-printable characters with the symbols below

-- Symbols used when `list` is enabled:
--   tab           → ▸ followed by spaces
--   trail         → trailing spaces shown as ·
--   extends/precedes → indicate that the line continues beyond the screen edge
--   nbsp          → non-breaking space shown as ␣
--   leadmultispace → indent guide: ┆ every N spaces matching shiftwidth
vim.opt.listchars = {
  tab           = "▸ ",
  trail         = "·",
  extends       = "»",
  precedes      = "«",
  nbsp          = "␣",
  leadmultispace = "·",
}

-- Preserve the indent of the current line when wrapping (visual only, no effect when wrap=false)
vim.opt.breakindent = true

-- ============================================================================
-- Splits
-- ============================================================================

vim.opt.splitright = true  -- Vertical splits open to the right
vim.opt.splitbelow = true  -- Horizontal splits open below

-- ============================================================================
-- Search
-- ============================================================================

-- Ignore case when the pattern is all lowercase; respect case when it has
-- any uppercase letter (smartcase requires ignorecase to be set first).
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- ============================================================================
-- Completion
-- ============================================================================

-- menu      → show popup menu even when there is only one match
-- menuone   → always show the popup (needed for extra info)
-- noselect  → don't auto-select the first item; let the user choose
vim.opt.completeopt = "menu,menuone,noselect"

-- Command-line completion: complete the longest common prefix first, then
-- cycle through all matches on the next press.
vim.opt.wildmode = "longest:full,full"

-- ============================================================================
-- Responsiveness
-- ============================================================================

-- Time (ms) after which the swap file is written and CursorHold fires.
-- Lower value means faster gitsigns/LSP diagnostic updates.
vim.opt.updatetime = 250

-- Time (ms) to wait for a mapped key sequence to complete.
-- Also controls which-key popup delay.
vim.opt.timeout = true
vim.opt.timeoutlen = 300

-- ============================================================================
-- Signs / diagnostics column
-- ============================================================================

-- Always reserve space for the sign column so the text doesn't shift when
-- diagnostics or git signs appear.
vim.opt.signcolumn = "yes"

-- ============================================================================
-- Undo
-- ============================================================================

-- Persist undo history to disk so it survives across Neovim restarts.
-- Files are stored in the default undodir (~/.local/share/nvim/undo/).
vim.opt.undofile = true

-- ============================================================================
-- Folding
-- Uses a Lua helper that delegates to treesitter when a parser is available,
-- and falls back to no folding otherwise. foldlevel=99 keeps all folds open
-- on file open.
-- ============================================================================
vim.opt.foldlevel = 99
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.require'user.functions'.foldexpr()"

-- ============================================================================
-- Scroll
-- ============================================================================

-- Smooth scrolling with <C-d>/<C-u>/etc. (Neovim 0.10+)
vim.opt.smoothscroll = true

-- ============================================================================
-- Spell checking
-- ============================================================================

vim.opt.spell = true
vim.opt.spelllang = "en_us"

-- ============================================================================
-- Session management
-- What gets saved/restored by :mksession (used by the SimpleSession autocmd).
-- ============================================================================
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "globals", "folds" }

-- ============================================================================
-- Formatting
-- Delegates gq / auto-format to conform.nvim instead of the built-in formatter.
-- ============================================================================
vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()"
