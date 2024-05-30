return {
  -- Phpactor in non-LSP mode for more PHP related features
  "phpactor/phpactor",
  ft = { "php" },
  build = "composer install --no-dev -o",
  config = function()
    -- [[ KEYMAPS ]]
    vim.keymap.set({ "n", "v" }, "<leader>cm", "<cmd>:PhpactorContextMenu<cr>", { desc = "Context menu" })
    vim.keymap.set({ "v" }, "<leader>crev", "<cmd>:PhpactorExtractExpression<cr>", { desc = "Extract variable" })
    vim.keymap.set({ "n" }, "<leader>crec", "<cmd>:PhpactorExtractConstant<cr>", { desc = "Extract constant" })
    vim.keymap.set({ "v" }, "<leader>crem", "<cmd>:PhpactorExtractMethod<cr>", { desc = "Extract method" })
    vim.keymap.set({ "n" }, "<leader>ccc", "<cmd>:PhpactorCopyClassName<cr>", { desc = "Copy class name" })
  end
}
