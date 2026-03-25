-- bufferline.nvim — renders open buffers as a tab bar along the top of the window
-- LSP diagnostics are shown as badges on each buffer tab so you can spot
-- errors without switching to the buffer first.
return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  keys = {
    { "<leader>bp", "<cmd>BufferLineTogglePin<cr>",            desc = "Toggle Pin" },
    { "<leader>bd", "<cmd>bd<cr>",                             desc = "Delete Buffer" },
    { "<leader>bD", "<cmd>bdelete!<cr>",                       desc = "Delete Buffer (forced)" },
    { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "Delete Non-Pinned Buffers" },
    { "<leader>bo", "<cmd>BufferLineCloseOthers<cr>",          desc = "Delete Other Buffers" },
    { "<leader>br", "<cmd>BufferLineCloseRight<cr>",           desc = "Delete Buffers to the Right" },
    { "<leader>bl", "<cmd>BufferLineCloseLeft<cr>",            desc = "Delete Buffers to the Left" },
  },
  opts = {
    options = {
      -- Show LSP error/warning counts as icons on each buffer tab
      diagnostics = "nvim_lsp",
      -- Reserve space on the left for neo-tree so the tab bar doesn't overlap
      -- the file explorer panel.
      offsets = {
        {
          filetype  = "neo-tree",
          highlight = "Directory",
          text_align = "left",
          separator = true,
        },
      },
    },
  },
  config = function(_, opts)
    require("bufferline").setup(opts)
  end,
}
