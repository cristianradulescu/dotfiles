return {
  --
  -- Debug with lsp-devtools:
  -- cmd = { "lsp-devtools", "agent", "--", vim.fn.expand("~/lsp/bin/php-diagls") },
  --
  cmd = { vim.fn.expand("~/lsp/bin/php-diagls") },
  root_markers = { "symfony.lock", ".git", "composer.json" },
  filetypes = { "php" },
}
