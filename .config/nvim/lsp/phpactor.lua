return {
  cmd = {
    "php",
    vim.fn.expand("/opt/phpactor-unstable/bin/phpactor"),
    "language-server",
  },
  root_markers = { "composer.json", "phpactor.json", ".git" },
  filetypes = { "php" },
}
