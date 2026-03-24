vim.lsp.enable({
  "bashls",
  "lua_ls",
  "twiggy_language_server",
  "docker_compose_language_service",
  "docker_language_server",
  -- "sqlls",
  "tsgo",
  "yamlls",
  "jsonls",
  "lemminx",
  "gopls",
  "php-diagls",
})

for _, server in ipairs(vim.g.php_lsp) do
  vim.lsp.enable(server)
end

-- Things to do when LSP is attached
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_on_attach", {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    -- Command to force Phpactor reindex
    if client.name == "phpactor" then
      vim.api.nvim_buf_create_user_command(args.buf, "PhpactorReindex", function(_)
        vim.notify("LSP: Starting Phpactor reindexing")
        vim.lsp.buf_notify(args.buf, "phpactor/indexer/reindex", {})
      end, { desc = "Phpactor reindex" })
    end

    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { buffer = args.buf, desc = "Signature documentation" })
  end,
})

-- Use LSP to highlight all references to the symbol under the cursor
-- Take into consideration that some LSP servers do not support documentHighlight, so we need to check if the server supports it before setting up the autocommands
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_document_highlight", {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    if client.server_capabilities.documentHighlightProvider then
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.document_highlight()
        end,
        desc = "Highlight references to symbol under cursor",
      })
      vim.api.nvim_create_autocmd("CursorMoved", {
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.clear_references()
        end,
        desc = "Clear highlighted references",
      })
    end
  end,
})

vim.diagnostic.config({
  virtual_lines = false,
  virtual_text = true,
  float = {
    source = true,
    header = "",
    prefix = function(_, i, total)
      if total > 1 then
        -- Show the number of diagnostics in the line
        return i .. "/" .. total .. ": ", ""
      end
      return "", ""
    end,
  },
})
