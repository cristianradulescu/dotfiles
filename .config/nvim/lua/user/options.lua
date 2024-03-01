--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
-- See `:help mapleader`
-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- [[ Setting options ]]
-- See `:help vim.o`

-- Transparent bg
vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
-- --
-- Color scheme
vim.o.background = 'dark'

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- Enable auto indenting and set it to spaces
vim.opt.smartindent = true
vim.opt.shiftwidth = 2

vim.o.tabstop = 2 -- Nb of spaces per tab
vim.o.softtabstop = 2 -- Nb of spaces per tab
vim.o.expandtab = true --Spaces instead of tabs
vim.o.wrap = false -- No word wrap

vim.o.cursorline = true -- Highlight cursor line
vim.o.relativenumber = true -- Line numbers start from current line 

-- Split directions - go right and bottom
vim.o.splitright = true
vim.o.splitbelow = true

-- Right vertical line
--vim.o.colorcolumn = '120'

