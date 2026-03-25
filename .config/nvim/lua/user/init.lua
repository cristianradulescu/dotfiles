-- Entry point for the user configuration module.
-- Loaded by init.lua at the repo root via require("user").
--
-- Load order matters here:
--   1. autocmds  — autocommand groups must exist before plugins fire events
--   2. options   — vim.opt settings and feature-flag globals (vim.g.*) must be
--                  set before lazy.nvim reads them during plugin loading
--   3. lazy      — bootstraps lazy.nvim and loads all plugin specs from lua/plugins/
--   4. lsp       — enables LSP servers and sets up LspAttach autocmds; runs
--                  after plugins so blink.cmp capabilities are already registered
--   5. keymaps   — base keymaps that don't depend on any plugin being loaded
require("user.autocmds")
require("user.options")
require("user.lazy")
require("user.lsp")
require("user.keymaps")
