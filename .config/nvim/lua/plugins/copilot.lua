-- copilot.lua — GitHub Copilot inline suggestions
-- Controlled by the vim.g.copilot_enabled flag in options.lua (default: false).
-- Only loaded when the flag is true, so there is no startup cost when disabled.
--
-- Uses zbirenbaum/copilot.lua (community rewrite) rather than the official
-- github/copilot.vim because it integrates better with Lua-based completion
-- engines and avoids VimScript overhead.
--
-- Keymaps (active in insert mode only):
--   <C-y>   accept the full suggestion
--   <M-w>   accept the next word only
--   <M-l>   accept the current line only
--   <M-]>   cycle to the next suggestion
--   <M-[>   cycle to the previous suggestion
--   <C-]>   dismiss the current suggestion
return {
  "zbirenbaum/copilot.lua",
  cond = function()
    return vim.g.copilot_enabled
  end,
  cmd = "Copilot",
  event = "InsertEnter",
  opts = {
    suggestion = {
      -- Disable inline suggestions when using blink-cmp integration
      enabled = false,
      -- Don't show the separate suggestion panel; inline ghost text is enough
      panel = { enabled = false },
      keymap = {
        accept = "<C-y>",
        accept_word = "<M-w>",
        accept_line = "<M-l>",
        next = "<M-]>",
        prev = "<M-[>",
        dismiss = "<C-]>",
      },
    },
    -- Enable Copilot in filetypes where it's off by default
    filetypes = {
      yaml = true,
      markdown = true,
    },
  },
}
