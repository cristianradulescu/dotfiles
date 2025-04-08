return {
  "ibhagwan/fzf-lua",
  enabled = function()
    return vim.g.picker == "FzfLua"
  end,
  config = function(_, opts)
    local fzflua = require("fzf-lua")
    fzflua.setup(opts)

    if vim.g.picker == "FzfLua" then
      vim.keymap.set("n", "<leader>?", function()
        fzflua.oldfiles({ cwd = vim.fn.getcwd() })
      end, { desc = "Find recently opened files" })

      vim.keymap.set("n", "<leader><leader>", function()
        fzflua.buffers()
      end, { desc = "Buffers" })

      vim.keymap.set("n", "<leader>/", function()
        fzflua.lines()
      end, { desc = "Fuzzily search in current buffer" })

      vim.keymap.set("n", "<leader>sf", function()
        fzflua.files()
      end, { desc = "Search file" })

      vim.keymap.set("n", "<leader>sh", function()
        fzflua.helptags()
      end, { desc = "Search help" })

      vim.keymap.set("n", "<leader>sk", function()
        fzflua.keymaps()
      end, { desc = "Search keymaps" })

      vim.keymap.set({ "n", "x" }, "<leader>sw", function()
        fzflua.grep_cword()
      end, { desc = "Search current word" })

      vim.keymap.set("n", "<leader>sg", function()
        fzflua.grep()
      end, { desc = "Search by grep" })

      vim.keymap.set("n", "<leader>sd", function()
        fzflua.diagnostics_document()
      end, { desc = "Search diagnostics" })

      vim.keymap.set("n", "<leader>sr", function()
        fzflua.resume()
      end, { desc = "Search resume" })

      vim.keymap.set("n", "<leader>ss", function()
        fzflua.lsp_document_symbols()
      end, { desc = "Search symbols" })

      vim.keymap.set("n", "<leader>sc", function()
        fzflua.lsp_workspace_symbols()
      end, { desc = "Search workspace symbols" })

      vim.keymap.set("n", "gd", function()
        fzflua.lsp_definitions()
      end, { desc = "Goto definition" })

      vim.keymap.set("n", "gr", function()
        fzflua.lsp_references()
      end, {
        desc = "Goto references",
      })

      vim.keymap.set("n", "gI", function()
        fzflua.lsp_implementations()
      end, { desc = "Goto implementation" })

      vim.keymap.set("n", "<leader>D", function()
        fzflua.lsp_typedefs()
      end, { desc = "Type definition" })
    end
  end,
}
