--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
-- See `:help mapleader`
-- Set <space> as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Toggle copilot
vim.g.copilot_enabled = true

-- Select picker to use (options: Telescope, FzfLua, Snacks)
vim.g.picker = "Snacks"

-- Select file explorer to use (options: NeoTree, Snacks)
vim.g.fileexplorer = "Snacks"

-- [[ Setting options ]]
-- See `:help vim.o`

-- Color scheme
vim.opt.background = "dark"

-- Default windows border
vim.opt.winborder = "rounded"

-- Set highlight on search
vim.opt.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.opt.mouse = "a"

-- Hide mode since it is already in status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help "clipboard"`
vim.opt.clipboard = "unnamedplus"

-- Keep indent for next lines when word wrap is enabled
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeout = true
vim.opt.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.opt.completeopt = "menu,menuone,noselect"

-- NOTE: You should make sure your terminal supports this
vim.opt.termguicolors = true

-- Enable auto indenting and set it to spaces
vim.opt.smartindent = true
vim.opt.shiftwidth = 2 -- Size of indent
vim.opt.shiftround = true --- Round indent

vim.opt.tabstop = 2 -- Nb of spaces per tab
vim.opt.softtabstop = 2 -- Nb of spaces per tab
vim.opt.expandtab = true --Spaces instead of tabs
vim.opt.wrap = false -- No word wrap
vim.opt.list = true -- Show non-printable chars
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.opt.cursorline = true -- Highlight current line
vim.opt.relativenumber = true -- Line numbers start from current line
vim.opt.scrolloff = 8 -- Lines of context to keep top/bottom
vim.opt.sidescrolloff = 8 -- Lines of context to keep left/right

-- Split directions - go right and bottom
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Right vertical line
vim.opt.colorcolumn = "120"

-- Command line completion mode
vim.opt.wildmode = "longest:full,full"

-- Folding
vim.opt.foldlevel = 99
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.require'user.functions'.foldexpr()"

-- Smooth scroll
vim.opt.smoothscroll = true

-- Spellcheck
vim.opt.spell = true
vim.opt.spelllang = "en_us"

-- Session management
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "globals", "folds" }

-- Set formatting to Conform
vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()"
