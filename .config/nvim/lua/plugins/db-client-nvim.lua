-- abcql.nvim — in-editor database client
-- Provides a split UI with a connection tree, a query editor, and a results
-- pane. Results can be exported to CSV or JSON directly from the buffer.
--
-- Keymaps (normal mode, prefix <leader>S):
--   SS   open the DB client UI
--   SC   close the DB client UI
--   ST   toggle the connection/schema tree
--   SR   toggle the query results panel
--   Se   execute the SQL query at the cursor
--   SD   activate/switch the datasource for the current buffer
--   Sxc  export the current result set as CSV
--   Sxj  export the current result set as JSON
return {
  "cristianradulescu/abcql.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  build = "make build",
  config = function()
    require("abcql").setup()

    local ui      = require("abcql.ui")
    local query   = require("abcql.db.query")
    local db      = require("abcql.db")
    local history = require("abcql.history")
    local exp     = require("abcql.export")

    vim.keymap.set("n", "<leader>SS",  function() ui.open() end,                                               { desc = "[Abcql] open" })
    vim.keymap.set("n", "<leader>SC",  function() ui.close() end,                                              { desc = "[Abcql] close" })
    vim.keymap.set("n", "<leader>ST",  function() ui.toggle_tree() end,                                        { desc = "[Abcql] toggle tree" })
    vim.keymap.set("n", "<leader>SR",  function() ui.toggle_results() end,                                     { desc = "[Abcql] toggle results" })
    vim.keymap.set("n", "<leader>Se",  function() query.execute_query_at_cursor() end,                         { desc = "[Abcql] execute query" })
    vim.keymap.set("n", "<leader>SD",  function() db.activate_datasource(vim.api.nvim_get_current_buf()) end,  { desc = "[Abcql] activate datasource" })
    vim.keymap.set("n", "<leader>Sh",  function() history.pick({ bufnr = vim.api.nvim_get_current_buf() }) end,            { desc = "[Abcql] query history" })
    vim.keymap.set("n", "<leader>Sxc", function() exp.export_current("csv") end,                               { desc = "[Abcql] export CSV" })
    vim.keymap.set("n", "<leader>Sxt", function() exp.export_current("tsv") end,                               { desc = "[Abcql] export TSV" })
    vim.keymap.set("n", "<leader>Sxj", function() exp.export_current("json") end,                              { desc = "[Abcql] export JSON" })
  end,
}
