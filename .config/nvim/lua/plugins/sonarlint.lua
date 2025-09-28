return {
  "https://gitlab.com/schrieveslaach/sonarlint.nvim",
  cond = function()
    return vim.g.sonarlint_enabled
  end,
  config = function()
    require("sonarlint").setup({
      server = {
        cmd = {
          "java",
          "-jar",
          vim.fn.expand("~/lsp/vscode-sonarlint/extension/server/sonarlint-ls.jar"),
          "-stdio",
          "-analyzers",
          vim.fn.expand("~/lsp/vscode-sonarlint/extension/analyzers/sonarphp.jar"),
        },
      },
      filetypes = { "php" },
    })
  end,
}
