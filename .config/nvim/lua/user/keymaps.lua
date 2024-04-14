-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- neo-tree
vim.keymap.set('n', '<leader>e', function()
    require('neo-tree.command').execute({ toggle = true, reveal = true, dir = vim.loop.cwd() })
  end, { desc = 'Toggle file [e]xplorer' }
)

-- Gitsigns
require("gitsigns").setup({
  on_attach = function(buffnr)
    vim.keymap.set("n", "<leader>ghp", require("gitsigns").preview_hunk, { buffer = buffnr, desc = "[H]unk [P]review" })
    vim.keymap.set("n", "<leader>ghr", require("gitsigns").reset_hunk, { buffer = buffnr, desc = "[H]unk [R]eset" })
    vim.keymap.set("n", "<leader>ghR", require("gitsigns").reset_buffer, { buffer = buffnr, desc = "[H]unk buffer [R]eset" })
    vim.keymap.set("n", "<leader>ghs", require("gitsigns").stage_hunk, { buffer = buffnr, desc = "[H]unk [S]tage" })
    vim.keymap.set("n", "<leader>ghus", require("gitsigns").undo_stage_hunk, { buffer = buffnr, desc = "[H]unk [Undo] [S]tage" })
    vim.keymap.set("n", "<leader>gbl", require("gitsigns").blame_line, { desc = "[G]it [B]lame [L]ine" })
    vim.keymap.set("n", "<leader>gbh", require("gitsigns").toggle_current_line_blame, { desc = "[G]it [B]lame Line [H]ints" })

    vim.keymap.set({"n", "v"}, "]c", function()
      if vim.wo.diff then return "]c" end
      vim.schedule(function() require("gitsigns").next_hunk() end)
      return "<Ignore>"
    end, {expr=true, buffer = buffnr, desc = "Next hunk"})
    vim.keymap.set({"n", "v"}, "[c", function()
      if vim.wo.diff then return "[c" end
      vim.schedule(function() require("gitsigns").prev_hunk() end)
      return "<Ignore>"
    end, {expr=true, buffer = buffnr, desc = "Previous hunk"})

  end
})

-- Git
vim.keymap.set("n", "<leader>gbf", "<cmd>Git blame<CR>", { desc = "[G]it [B]lame [F]ile" })

-- Telescope
-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
 -- You can pass additional configuration to telescope to change theme, layout, etc.
 require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
   winblend = 10,
   previewer = false,
 })
end, { desc = '[/] Fuzzily search in current buffer' })

-- Search in all files including hidden and ignored by Git
vim.keymap.set('n', '<leader>sf', function()
 require('telescope.builtin').find_files({ hidden = true, no_ignore = true })
end, { desc = '[S]earch [F]iles' })

vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', require('telescope.builtin').keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>ss', require('telescope.builtin').lsp_document_symbols, { desc = '[S]earch [S]ymbols' })

-- Trouble diagnostics
vim.keymap.set("n", "<leader>q", function()
  require("trouble").open("document_diagnostics")
end, { desc = "Open diagnostics list" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
-- vim.keymap.set("n", "<leader>qq", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
