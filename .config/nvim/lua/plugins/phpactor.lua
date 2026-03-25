-- phpactor — PHP refactoring tool (non-LSP mode)
-- Loaded from a local checkout at ~/lsp/phpactor rather than from a registry,
-- allowing the tool to be updated independently of the plugin manager.
-- Only active for PHP filetypes; composer dependencies are installed
-- automatically on first load via the `build` hook.
--
-- Used alongside the PHP LSP servers (intelephense/phpactor LSP mode) for
-- refactoring operations that LSP code actions don't cover well.
--
-- Keymaps (PHP buffers only):
--   <leader>cm    open the Phpactor context menu (all available actions)
--   <leader>crev  extract the selected expression into a variable  (visual)
--   <leader>crec  extract the expression under cursor into a constant
--   <leader>crem  extract the selected code block into a new method (visual)
--   <leader>ccc   copy the fully-qualified class name to the clipboard
return {
  dir   = vim.fn.expand("~/lsp/phpactor"),
  ft    = { "php" },
  build = "composer install --no-dev -o",
  config = function()
    vim.keymap.set({ "n", "v" }, "<leader>cm",   "<cmd>PhpactorContextMenu<cr>",       { desc = "PHP context menu" })
    vim.keymap.set("v",          "<leader>crev",  "<cmd>PhpactorExtractExpression<cr>", { desc = "PHP extract variable" })
    vim.keymap.set("n",          "<leader>crec",  "<cmd>PhpactorExtractConstant<cr>",   { desc = "PHP extract constant" })
    vim.keymap.set("v",          "<leader>crem",  "<cmd>PhpactorExtractMethod<cr>",     { desc = "PHP extract method" })
    vim.keymap.set("n",          "<leader>ccc",   "<cmd>PhpactorCopyClassName<cr>",     { desc = "PHP copy class name" })
  end,
}
