return {
  "ibhagwan/fzf-lua",
  enabled = function()
    return vim.g.picker == "FzfLua"
  end,
  config = function(_, opts)
    local fzflua = require("fzf-lua")
    fzflua.setup(opts)

    if vim.g.picker == "FzfLua" then
      local keymaps = require("user.keymaps-picker")

      keymaps.oldfiles(fzflua, "oldfiles", { cwd = vim.fn.getcwd() })
      keymaps.buffers(fzflua, "buffers", {})
      keymaps.lines(fzflua, "lines", {})
      keymaps.files(fzflua, "files", {})
      keymaps.help(fzflua, "helptags", {})
      keymaps.keymaps(fzflua, "keymaps", {})
      keymaps.search_cword(fzflua, "grep_cword", {})
      keymaps.search_word(fzflua, "grep", {})
      keymaps.search_diagnostics(fzflua, "diagnostics_document", {})
      keymaps.search_resume(fzflua, "resume", {})
      keymaps.search_document_symbols(fzflua, "lsp_document_symbols", {})
      keymaps.search_workspace_symbols(fzflua, "lsp_workspace_symbols", {})
      keymaps.goto_definition(fzflua, "lsp_definitions", {})
      keymaps.goto_references(fzflua, "lsp_references", {})
      keymaps.goto_implementation(fzflua, "lsp_implementations", {})
      keymaps.goto_typedef(fzflua, "lsp_typedefs", {})
    end
  end,
}
