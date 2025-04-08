return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    input = { enabled = true },
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
        snacks.explorer()
      end, { desc = "File explorer" })
    end

    if vim.g.picker == "Snacks" then
      vim.keymap.set("n", "<leader>?", function()
        snacks.picker.recent()
      end, { desc = "Find recently opened files" })

      vim.keymap.set("n", "<leader><leader>", function()
        snacks.picker.buffers()
      end, { desc = "Buffers" })

      vim.keymap.set("n", "<leader>/", function()
        snacks.picker.lines()
      end, { desc = "Fuzzily search in current buffer" })

      vim.keymap.set("n", "<leader>sf", function()
        snacks.picker.files()
      end, { desc = "Search file" })

      vim.keymap.set("n", "<leader>sh", function()
        snacks.picker.health()
      end, { desc = "Search help" })

      vim.keymap.set("n", "<leader>sk", function()
        snacks.picker.keymaps()
      end, { desc = "Search keymaps" })

      vim.keymap.set({ "n", "x" }, "<leader>sw", function()
        snacks.picker.grep_word()
      end, { desc = "Search current word" })

      vim.keymap.set("n", "<leader>sg", function()
        snacks.picker.grep()
      end, { desc = "Search by grep" })

      vim.keymap.set("n", "<leader>sd", function()
        snacks.picker.diagnostics_buffer()
      end, { desc = "Search diagnostics" })

      vim.keymap.set("n", "<leader>sr", function()
        snacks.picker.resume()
      end, { desc = "Search resume" })

      vim.keymap.set("n", "<leader>ss", function()
        snacks.picker.lsp_symbols()
      end, { desc = "Search symbols" })

      vim.keymap.set("n", "<leader>sc", function()
        snacks.picker.lsp_workspace_symbols()
      end, { desc = "Search workspace symbols" })

      vim.keymap.set("n", "gd", function()
        snacks.picker.lsp_definitions()
      end, { desc = "Goto definition" })

      vim.keymap.set("n", "gr", function()
        snacks.picker.lsp_references()
      end, {
        desc = "Goto references",
      })

      vim.keymap.set("n", "gI", function()
        snacks.picker.lsp_implementations()
      end, { desc = "Goto implementation" })

      vim.keymap.set("n", "<leader>D", function()
        snacks.picker.lsp_type_definitions()
      end, { desc = "Type definition" })
    end
  end,
}
