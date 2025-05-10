vim.api.nvim_create_autocmd('LspAttach', {
  pattern = { "*.php" },
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client ~= nil and client.name == "phpactor" then
      vim.api.nvim_buf_create_user_command(ev.buf, "PhpactorReindex", function(_)
        vim.notify("LSP: Starting Phpactor reindexing")
        vim.lsp.buf_notify(0, "phpactor/indexer/reindex", {})
      end, { desc = "Phpactor reindex" })
    end
  end,
})

return {
  cmd = {
    "php",
    "/opt/phpactor/bin/phpactor",
    "language-server",
  },
  root_markers = { ".git", "composer.json" },
  filetypes = { "php" }
}
