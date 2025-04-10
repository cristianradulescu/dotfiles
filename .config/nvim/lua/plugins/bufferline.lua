return {
  -- Show buffers as tabs
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  keys = {
    { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Toggle Pin" },
    { "<leader>bd", "<cmd>bd<cr>", desc = "Delete Buffer" },
    { "<leader>b!", "<cmd>bdelete!<cr>", desc = "Delete Buffer (forced)" },
    { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "Delete Non-Pinned Buffers" },
    { "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "Delete Other Buffers" },
    { "<leader>br", "<cmd>BufferLineCloseRight<cr>", desc = "Delete Buffers to the Right" },
    { "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", desc = "Delete Buffers to the Left" },
  },
  opts = {
    options = {
      -- Mark buffers with errors
      diagnostics = "nvim_lsp",
      offsets = {
        {
          filetype = "neo-tree",
          highlight = "Directory",
          text_align = "left",
          separator = true
        },
      },
    },
  },
  config = function(_, opts)
    require("bufferline").setup(opts)
  end,
}
