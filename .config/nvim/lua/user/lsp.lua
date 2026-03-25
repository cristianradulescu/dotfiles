-- lsp.lua — LSP server enablement and global LSP behaviour
--
-- Server configuration files live in lsp/*.lua and use the Neovim 0.11+
-- native vim.lsp.config() / vim.lsp.enable() API. This file calls
-- vim.lsp.enable() for each server that should be active.
--
-- PHP LSP servers are controlled separately by the vim.g.php_lsp feature flag
-- (set in options.lua) so they can be swapped without editing this file.
-- Options: "intelephense", "phpactor" (or both simultaneously).
--
-- Servers without a hand-written lsp/*.lua config file (bashls, gopls, tsgo,
-- etc.) inherit their default cmd / root_markers / filetypes from nvim-lspconfig's
-- built-in catalogue (see plugins/nvim-lspconfig.lua).
--
-- LspAttach autocmds
-- Two separate augroups handle different concerns on attach:
--
--   lsp_on_attach
--     - Registers the :PhpactorReindex command when phpactor attaches, which
--       triggers a full workspace reindex (useful after composer updates).
--     - Maps <C-k> to signature help for every buffer that has an LSP client.
--
--   lsp_document_highlight
--     - When the attached server supports documentHighlight, sets up
--       CursorHold/CursorHoldI to highlight all references to the symbol
--       under the cursor, and CursorMoved to clear them.
--       CursorHold fires after vim.opt.updatetime ms of inactivity (250 ms).
--
-- Diagnostics display
--   virtual_text   enabled — show the message inline at the end of the line
--   virtual_lines  disabled — don't use the multi-line virtual-lines style
--   float          when multiple diagnostics share a line, prefix each with
--                  "i/total:" so they are individually identifiable

-- ============================================================================
-- Server enablement
-- ============================================================================

vim.lsp.enable({
  "bashls",
  "lua_ls",
  "twiggy_language_server",
  "docker_compose_language_service",
  "docker_language_server",
  -- "sqlls",  -- disabled: sqlfluff (via conform) is used for SQL files instead
  "tsgo",
  "yamlls",
  "jsonls",
  "lemminx",  -- XML
  "gopls",
  "php-diagls",
})

-- Enable PHP LSP server(s) selected via the feature flag in options.lua
for _, server in ipairs(vim.g.php_lsp) do
  vim.lsp.enable(server)
end

-- ============================================================================
-- LspAttach — per-client setup
-- ============================================================================

vim.api.nvim_create_autocmd("LspAttach", {
  group    = vim.api.nvim_create_augroup("lsp_on_attach", {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    -- Phpactor-specific: expose a command to trigger a full workspace reindex.
    -- Useful after running composer install/update in a PHP project.
    if client.name == "phpactor" then
      vim.api.nvim_buf_create_user_command(args.buf, "PhpactorReindex", function(_)
        vim.notify("LSP: Starting Phpactor reindexing")
        vim.lsp.buf_notify(args.buf, "phpactor/indexer/reindex", {})
      end, { desc = "Phpactor: reindex workspace" })
    end

    -- Show function signature help in a floating window
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, {
      buffer = args.buf,
      desc   = "LSP signature help",
    })
  end,
})

-- ============================================================================
-- LspAttach — document highlight
-- Highlights all occurrences of the symbol under the cursor after the cursor
-- has been idle for updatetime ms. Cleared as soon as the cursor moves.
-- Only registered when the server advertises the documentHighlight capability.
-- ============================================================================

vim.api.nvim_create_autocmd("LspAttach", {
  group    = vim.api.nvim_create_augroup("lsp_document_highlight", {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    if not client.server_capabilities.documentHighlightProvider then
      return
    end

    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      buffer   = args.buf,
      desc     = "Highlight references to symbol under cursor",
      callback = function()
        vim.lsp.buf.document_highlight()
      end,
    })

    vim.api.nvim_create_autocmd("CursorMoved", {
      buffer   = args.buf,
      desc     = "Clear symbol highlight references",
      callback = function()
        vim.lsp.buf.clear_references()
      end,
    })
  end,
})

-- ============================================================================
-- Diagnostics display
-- ============================================================================

vim.diagnostic.config({
  virtual_lines = false,  -- single-line virtual text is less visually noisy
  virtual_text  = true,

  float = {
    source = true,  -- show the source server name (e.g. "phpactor") in the popup
    header = "",
    -- When multiple diagnostics share a line, prefix each entry with "i/total:"
    -- so they can be individually identified in the floating window.
    prefix = function(_, i, total)
      if total > 1 then
        return i .. "/" .. total .. ": ", ""
      end
      return "", ""
    end,
  },
})
