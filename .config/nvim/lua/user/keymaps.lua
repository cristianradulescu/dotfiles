-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
-- vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
-- vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
-- vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
-- vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- Resize window using <ctrl> arrow keys
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Move Lines
vim.keymap.set("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
vim.keymap.set("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
vim.keymap.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
vim.keymap.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move Down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move Up" })

-- buffers
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
vim.keymap.set("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- Clear search with <esc>
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })

-- PHP stuff: add semicolon at the end of line
vim.keymap.set("i", "<A-;>", function()
  local buffnr = vim.api.nvim_get_current_buf()

  if vim.bo[buffnr].filetype == "php" then
    return "<esc><cmd>TSTextobjectGotoNextEnd @statement.outer<cr>A;"
  end

  return "<Ignore>"
end, { expr = true, desc = "Add endline semicolon for PHP files" })

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
    vim.keymap.set("n", "<leader>ghR", require("gitsigns").reset_buffer,
      { buffer = buffnr, desc = "[H]unk buffer [R]eset" })
    vim.keymap.set("n", "<leader>ghs", require("gitsigns").stage_hunk, { buffer = buffnr, desc = "[H]unk [S]tage" })
    vim.keymap.set("n", "<leader>ghus", require("gitsigns").undo_stage_hunk,
      { buffer = buffnr, desc = "[H]unk [Undo] [S]tage" })
    vim.keymap.set("n", "<leader>gbl", require("gitsigns").blame_line, { desc = "[G]it [B]lame [L]ine" })
    vim.keymap.set("n", "<leader>gbh", require("gitsigns").toggle_current_line_blame,
      { desc = "[G]it [B]lame Line [H]ints" })

    vim.keymap.set({ "n", "v" }, "]c", function()
      if vim.wo.diff then return "]c" end
      vim.schedule(function() require("gitsigns").next_hunk() end)
      return "<Ignore>"
    end, { expr = true, buffer = buffnr, desc = "Next hunk" })
    vim.keymap.set({ "n", "v" }, "[c", function()
      if vim.wo.diff then return "[c" end
      vim.schedule(function() require("gitsigns").prev_hunk() end)
      return "<Ignore>"
    end, { expr = true, buffer = buffnr, desc = "Previous hunk" })
  end
})

-- Git
vim.keymap.set("n", "<leader>gbf", "<cmd>Git blame<CR>", { desc = "[G]it [B]lame [F]ile" })
vim.keymap.set("n", "<leader>gdf", "<cmd>DiffviewFileHistory %<cr>", { desc = "Git file history" })

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
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', require('telescope.builtin').keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>ss', require('telescope.builtin').lsp_document_symbols, { desc = '[S]earch [S]ymbols' })
vim.keymap.set("n", "<leader>sc", require("telescope.builtin").lsp_dynamic_workspace_symbols,
  { desc = "Search Workspace Symbols" })
vim.keymap.set("n", "gd", function()
  require("telescope.builtin").lsp_definitions({ fname_width = 75 })
end, { desc = "[G]oto [D]efinition" })
vim.keymap.set("n", "gr", function()
  -- TODO: add fname_width globally
  require("telescope.builtin").lsp_references({ fname_width = 75 })
end, {
  desc =
  "[G]oto [R]eferences"
})
vim.keymap.set("n", "gI", function()
  require("telescope.builtin").lsp_implementations({ fname_width = 75 })
end, { desc = "[G]oto [I]mplementation" })
vim.keymap.set("n", "<leader>D", function()
  require("telescope.builtin").lsp_type_definitions({ fname_width = 75 })
end, { desc = "Type [D]efinition" })

-- Trouble diagnostics
vim.keymap.set("n", "<leader>q", function()
  require("trouble").open("document_diagnostics")
end, { desc = "Open diagnostics list" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
-- vim.keymap.set("n", "<leader>qq", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })

vim.keymap.set("n", "<leader>cf", "<cmd>Format<cr>", { desc = "Format code" })
