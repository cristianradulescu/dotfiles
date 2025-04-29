---@diagnostic disable: missing-fields
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    input = { enabled = true },
    layout = { enabled = true },
    bigfile = { enabled = true },
    picker = {
      enabled = function()
        return vim.g.picker == "Snacks"
      end,
    },
    explorer = {
      enabled = function()
        return vim.g.fileexplorer == "Snacks"
      end,
    },
  },
  config = function(_, opts)
    local snacks = require("snacks")
    snacks.setup(opts)

    if vim.g.fileexplorer == "Snacks" then
      vim.keymap.set("n", "<leader>e", function()
        snacks.explorer({ hidden = true, ignored = true })
      end, { desc = "File explorer" })
    end

    if vim.g.picker == "Snacks" then
      local keymaps = require("user.keymaps-picker")

      keymaps.oldfiles(snacks.picker, "recent", { filter = { cwd = true } })
      keymaps.buffers(snacks.picker, "buffers", {})
      keymaps.lines(snacks.picker, "lines", {})
      keymaps.files(snacks.picker, "files", {})
      keymaps.help(snacks.picker, "help", {})
      keymaps.keymaps(snacks.picker, "keymaps", {})
      keymaps.search_cword(snacks.picker, "grep_word", {})
      keymaps.search_word(snacks.picker, "grep", {})
      keymaps.search_diagnostics(snacks.picker, "diagnostics_buffer", {})
      keymaps.search_resume(snacks.picker, "resume", {})
      keymaps.search_document_symbols(snacks.picker, "lsp_symbols", {})
      keymaps.search_workspace_symbols(snacks.picker, "lsp_workspace_symbols", {})
      keymaps.goto_definition(snacks.picker, "lsp_definitions", {})
      keymaps.goto_references(snacks.picker, "lsp_references", {})
      keymaps.goto_implementation(snacks.picker, "lsp_implementations", {})
      keymaps.goto_typedef(snacks.picker, "lsp_type_definitions", {})
      keymaps.code_action(nil, nil, {})
    end
  end,
}
