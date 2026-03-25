-- lazy.lua — plugin manager bootstrap and setup
-- Installs lazy.nvim from GitHub if it isn't already present, then calls
-- lazy.setup() to discover and load all plugin specs from lua/plugins/.
--
-- lazy.nvim is cloned to the standard data directory:
--   ~/.local/share/nvim/lazy/lazy.nvim
-- It is prepended to runtimepath so it is available before any plugin loads.
--
-- Configuration notes:
--   change_detection  disabled — avoids the "config changed, restart?" prompt
--                     on every save while editing the config
--   checker           disabled — automatic update checks are not run on startup;
--                     run :Lazy update manually when you want to update
--   disabled_plugins  built-in Neovim plugins that are never used are disabled
--                     to shave a small amount off startup time:
--                       gzip / tarPlugin / zipPlugin  archive file handlers
--                       netrwPlugin                   file explorer (replaced by neo-tree)
--                       tohtml                        :TOhtml converter
--                       tutor                         :Tutor interactive lessons

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Bootstrap: clone lazy.nvim if this is a fresh install
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",          -- partial clone: skip blobs initially
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",             -- pin to the latest stable release
    lazypath,
  })
end

-- Make lazy.nvim available before any require() calls
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- Auto-import every file under lua/plugins/ as a plugin spec
    { import = "plugins" },
  },

  change_detection = {
    enabled = false,  -- don't watch config files for changes
    notify  = false,  -- don't show a notification when changes are detected
  },

  checker = {
    -- Don't auto-check for plugin updates on startup
    enabled = false,
  },

  performance = {
    rtp = {
      -- Disable unused built-in plugins to reduce startup time
      disabled_plugins = {
        "gzip",
        "netrwPlugin",  -- replaced by neo-tree
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
