return {
    "cristianradulescu/abcql.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("abcql").setup()

      local abcql_ui = require("abcql.ui")
      vim.keymap.set({ "n" }, "<leader>SS", function() abcql_ui.open() end, { desc = "abcql open" })
      vim.keymap.set({ "n" }, "<leader>SC", function() abcql_ui.close() end, { desc = "abcql close" })
      vim.keymap.set({ "n" }, "<leader>ST", function() abcql_ui.toggle_tree() end, { desc = "abcql tree" })
      vim.keymap.set({ "n" }, "<leader>SR", function() abcql_ui.toggle_results() end, { desc = "abcql results" })
      vim.keymap.set({ "n" }, "<leader>Se", function() require("abcql.db.query").execute_query_at_cursor() end, { desc = "abcql execute query" })
      vim.keymap.set({ "n" }, "<leader>SD", function() require("abcql.db").activate_datasource(vim.api.nvim_get_current_buf()) end, { desc = "abcql activate datasource" })
      vim.keymap.set({ "n" }, "<leader>Sxc", function() require("abcql.export").export_current("csv") end, { desc = "abcql export csv" })
      vim.keymap.set({ "n" }, "<leader>Sxj", function() require("abcql.export").export_current("json") end, { desc = "abcql export json" })
    end,
}
