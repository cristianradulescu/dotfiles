-- httpfly.nvim — HTTP request runner for *.http files
-- Works like VS Code REST Client or JetBrains HTTP Client: write requests
-- directly in a .http file and execute them without leaving Neovim.
-- Only loaded for http filetypes (see ftdetect/http.lua).
return {
  "cristianradulescu/httpfly.nvim",
  opts = {
    output_style = "markdown",
  },
}
