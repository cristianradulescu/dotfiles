-- keymaps.lua — base keymaps that don't depend on any plugin
-- Plugin-specific keymaps live in their respective plugin spec files.
-- Picker-related keymaps (LSP navigation, grep, etc.) live in keymaps-picker.lua.
--
-- Keymap reference:
--
--   Navigation
--     <C-h/j/k/l>          move focus between splits (normal mode)
--     <C-h/j/k/l>          move focus between splits (terminal mode, exits insert first)
--     k / j                move by visual line when no count is given (handles wrapped lines)
--
--   Window resizing
--     <C-Up/Down>          increase / decrease window height by 2
--     <C-Left/Right>       decrease / increase window width by 2
--
--   Line movement
--     <A-j/k>              move the current line (or selection) down / up
--                          and re-indent it (normal, insert, and visual modes)
--
--   Search
--     <Esc>                clear search highlight and return to normal mode
--
--   Terminal
--     <leader>th           open a horizontal terminal split
--     <leader>tv           open a vertical terminal split
--     <leader>tt           open a terminal in a new tab
--     <Esc>                exit terminal insert mode (maps to <C-\><C-n>)

-- Prevent <Space> from moving the cursor when used as the leader key
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- ============================================================================
-- Navigation
-- ============================================================================

-- When wrap is off these behave like normal k/j. When wrap is on and a count
-- is not given they move by screen lines (gk/gj) so the cursor doesn't jump
-- over a visually wrapped paragraph. With a count they use real lines so that
-- relative-number jumps like 5j work as expected.
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Jump between splits without the <C-w> prefix
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window",  remap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- ============================================================================
-- Window resizing
-- ============================================================================

vim.keymap.set("n", "<C-Up>",    "<cmd>resize +2<cr>",          { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>",  "<cmd>resize -2<cr>",          { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>",  "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- ============================================================================
-- Line movement
-- Move the current line or selected block and re-apply indentation (==).
-- In insert mode, <Esc> is prepended to exit insert, move the line, then `gi`
-- returns the cursor to its insert position.
-- ============================================================================

vim.keymap.set("n", "<A-j>", "<cmd>m .+1<cr>==",        { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", "<cmd>m .-2<cr>==",        { desc = "Move line up" })
vim.keymap.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
vim.keymap.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv",        { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv",        { desc = "Move selection up" })

-- ============================================================================
-- Search
-- ============================================================================

-- <Esc> in normal or insert mode clears any active search highlight in
-- addition to its default behaviour. Useful after a search leaves matches
-- highlighted on screen.
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear search highlight" })

-- ============================================================================
-- Terminal
-- ============================================================================

-- Exit terminal insert mode with <Esc> instead of the default <C-\><C-n>,
-- which is awkward to type.
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Navigate from terminal mode to other splits without needing to exit insert
-- mode first — each mapping exits terminal mode then moves to the split.
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Terminal: go to left window" })
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Terminal: go to lower window" })
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Terminal: go to upper window" })
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Terminal: go to right window" })

-- Open terminals in different layouts
vim.keymap.set("n", "<leader>th", ":split | terminal<CR>",  { desc = "Terminal in horizontal split" })
vim.keymap.set("n", "<leader>tv", ":vsplit | terminal<CR>", { desc = "Terminal in vertical split" })
vim.keymap.set("n", "<leader>tt", ":tabnew | terminal<CR>", { desc = "Terminal in new tab" })
