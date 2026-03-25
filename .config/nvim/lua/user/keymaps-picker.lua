-- keymaps-picker — picker-agnostic keymap wiring
--
-- This module decouples keymap definitions from the specific picker backend
-- (fzf-lua or Snacks). Each function registers one logical keymap by calling
-- the appropriate method on whatever picker object is passed in.
--
-- Usage pattern (from a picker plugin's config function):
--   local keymaps = require("user.keymaps-picker")
--   keymaps.files(fzflua, "files", {})
--   keymaps.goto_definition(fzflua, "lsp_definitions", {})
--
-- This means swapping the picker backend only requires changing the arguments
-- passed to these functions (done in fzf-lua.lua and snacks.lua.disabled),
-- not editing the keymap bindings themselves.
--
-- Keymap reference:
--   <leader>?        recently opened files (cwd only)
--   <leader><leader> open buffer list
--   <leader>/        fuzzy search lines in the current buffer
--   <leader>sf       search files
--   <leader>sm       search marks
--   <leader>sh       search help tags
--   <leader>sk       search keymaps
--   <leader>sw       search word under cursor (normal + visual)
--   <leader>sg       grep / search by pattern
--   <leader>sd       search document diagnostics
--   <leader>sr       resume last search
--   <leader>ss       search document symbols (LSP)
--   <leader>sc       search workspace symbols (LSP)
--   gd               go to definition (LSP)
--   gr               go to references (LSP)
--   gI               go to implementation (LSP)
--   <leader>D        go to type definition (LSP)
--   <leader>ca       code actions (LSP, or vim.lsp.buf.code_action fallback)

local M = {}

--- Recently opened files (restricted to cwd).
function M.oldfiles(picker, picker_func, picker_func_params)
  vim.keymap.set("n", "<leader>?", function()
    picker[picker_func](picker_func_params)
  end, { desc = "Find recently opened files" })
end

--- Open buffer list.
function M.buffers(picker, picker_func, picker_func_params)
  vim.keymap.set("n", "<leader><leader>", function()
    picker[picker_func](picker_func_params)
  end, { desc = "Buffers" })
end

--- Fuzzy search lines in the current buffer.
function M.lines(picker, picker_func, picker_func_params)
  vim.keymap.set("n", "<leader>/", function()
    picker[picker_func](picker_func_params)
  end, { desc = "Fuzzily search in current buffer" })
end

--- Search project files.
function M.files(picker, picker_func, picker_func_params)
  vim.keymap.set("n", "<leader>sf", function()
    picker[picker_func](picker_func_params)
  end, { desc = "Search file" })
end

--- Search marks.
function M.marks(picker, picker_func, picker_func_params)
  vim.keymap.set("n", "<leader>sm", function()
    picker[picker_func](picker_func_params)
  end, { desc = "Search marks" })
end

--- Search help tags.
function M.help(picker, picker_func, picker_func_params)
  vim.keymap.set("n", "<leader>sh", function()
    picker[picker_func](picker_func_params)
  end, { desc = "Search help" })
end

--- Search defined keymaps.
function M.keymaps(picker, picker_func, picker_func_params)
  vim.keymap.set("n", "<leader>sk", function()
    picker[picker_func](picker_func_params)
  end, { desc = "Search keymaps" })
end

--- Search for the word under the cursor (normal and visual mode).
function M.search_cword(picker, picker_func, picker_func_params)
  vim.keymap.set({ "n", "x" }, "<leader>sw", function()
    picker[picker_func](picker_func_params)
  end, { desc = "Search current word" })
end

--- Open a grep/live-grep prompt.
function M.search_word(picker, picker_func, picker_func_params)
  vim.keymap.set("n", "<leader>sg", function()
    picker[picker_func](picker_func_params)
  end, { desc = "Search by grep" })
end

--- Search diagnostics for the current document.
function M.search_diagnostics(picker, picker_func, picker_func_params)
  vim.keymap.set("n", "<leader>sd", function()
    picker[picker_func](picker_func_params)
  end, { desc = "Search diagnostics" })
end

--- Resume the last picker search session.
function M.search_resume(picker, picker_func, picker_func_params)
  vim.keymap.set("n", "<leader>sr", function()
    picker[picker_func](picker_func_params)
  end, { desc = "Search resume" })
end

--- Search LSP document symbols (functions, classes, variables in current file).
function M.search_document_symbols(picker, picker_func, picker_func_params)
  vim.keymap.set("n", "<leader>ss", function()
    picker[picker_func](picker_func_params)
  end, { desc = "Search symbols" })
end

--- Search LSP workspace symbols (across all project files).
function M.search_workspace_symbols(picker, picker_func, picker_func_params)
  vim.keymap.set("n", "<leader>sc", function()
    picker[picker_func](picker_func_params)
  end, { desc = "Search workspace symbols" })
end

--- Go to the definition of the symbol under the cursor.
function M.goto_definition(picker, picker_func, picker_func_params)
  vim.keymap.set("n", "gd", function()
    picker[picker_func](picker_func_params)
  end, { desc = "Goto definition" })
end

--- List all references to the symbol under the cursor.
function M.goto_references(picker, picker_func, picker_func_params)
  vim.keymap.set("n", "gr", function()
    picker[picker_func](picker_func_params)
  end, { desc = "Goto references" })
end

--- Go to the implementation of an interface method or abstract member.
function M.goto_implementation(picker, picker_func, picker_func_params)
  vim.keymap.set("n", "gI", function()
    picker[picker_func](picker_func_params)
  end, { desc = "Goto implementation" })
end

--- Go to the type definition of the symbol under the cursor.
function M.goto_typedef(picker, picker_func, picker_func_params)
  vim.keymap.set("n", "<leader>D", function()
    picker[picker_func](picker_func_params)
  end, { desc = "Type definition" })
end

--- Trigger code actions.
-- When picker is nil (e.g. Snacks, which uses the native vim.ui.select),
-- falls back to vim.lsp.buf.code_action() directly.
function M.code_action(picker, picker_func, picker_func_params)
  vim.keymap.set("n", "<leader>ca", function()
    if picker == nil then
      vim.lsp.buf.code_action()
    else
      picker[picker_func](picker_func_params)
    end
  end, { desc = "Code actions" })
end

return M
