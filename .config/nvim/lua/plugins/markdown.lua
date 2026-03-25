-- render-markdown.nvim — rich in-buffer Markdown rendering
-- Replaces raw Markdown syntax with styled visual elements (headings,
-- code blocks, tables, checkboxes) without modifying the underlying text.
--
-- Active in three contexts:
--   markdown           regular .md files
--   codecompanion      AI chat window (renders assistant responses)
--   blink-cmp-documentation  completion documentation popups
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {},
    ft   = { "markdown", "codecompanion", "blink-cmp-documentation" },
  },
}
