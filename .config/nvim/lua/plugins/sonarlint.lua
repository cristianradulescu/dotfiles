return {
  "https://gitlab.com/schrieveslaach/sonarlint.nvim",
  config = function()
    require("sonarlint").setup({
      server = {
        cmd = {
          "java",
          "-jar",
          "/opt/vscode-sonarlint/extension/server/sonarlint-ls.jar",
          "-stdio",
          "-analyzers",
          "/opt/vscode-sonarlint/extension/analyzers/sonarphp.jar"
        },
      },
      filetypes = { "php" },
    })
  end,
}
