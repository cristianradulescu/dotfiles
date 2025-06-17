return {
  -- {
  --   -- Official GitHub Copilot plugin for Neovim
  --   "github/copilot.vim",
  --   cond = function()
  --     return vim.g.copilot_enabled
  --   end,
  -- },

  {
    -- Copilot plugin with some improvements
    "zbirenbaum/copilot.lua",
    cond = function()
      return vim.g.copilot_enabled
    end,
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = {
        auto_trigger = true,
        enable = true,
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
      filetypes = {
        yaml = true,
        markdown = true,
      },
    },
  },
}
