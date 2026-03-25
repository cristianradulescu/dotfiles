local M = {}

-- ============================================================================
-- foldexpr — treesitter-aware fold expression
-- Used by vim.opt.foldexpr in options.lua. Delegates to the treesitter fold
-- expression when a parser is available for the current buffer, and returns
-- "0" (no folding) otherwise. This avoids errors in special buffers (help,
-- terminals, quickfix) that have no filetype or no treesitter parser.
-- Adapted from LazyVim.
-- ============================================================================
function M.foldexpr()
  local buf = vim.api.nvim_get_current_buf()

  -- Non-file buffers (terminal, quickfix, etc.) have no parseable content
  if vim.bo[buf].buftype ~= "" then
    return "0"
  end

  -- No filetype yet means treesitter won't have a parser to offer
  if vim.bo[buf].filetype == "" then
    return "0"
  end

  -- Try to get a treesitter parser; if one exists, use its fold expression
  local ok = pcall(vim.treesitter.get_parser, buf)
  if ok then
    return vim.treesitter.foldexpr()
  end

  return "0"
end

-- ============================================================================
-- fg / color — highlight group colour helpers
-- Utility functions for reading resolved foreground/background colours from
-- highlight groups. Used by lualine.lua to inherit colours from the active
-- colourscheme rather than hardcoding hex values.
-- Adapted from LazyVim.
-- ============================================================================

--- Return the foreground colour of a highlight group as a { fg = "#rrggbb" } table.
--- Returns nil if the group doesn't exist or has no foreground colour.
---@param name string  Highlight group name (e.g. "Normal", "DiagnosticError")
---@return {fg?: string}?
function M.fg(name)
  local color = M.color(name)
  return color and { fg = color } or nil
end

--- Resolve the foreground or background colour of a highlight group.
--- Returns the colour as a "#rrggbb" hex string, or nil if not available.
---@param name string   Highlight group name
---@param bg?  boolean  When true, return the background colour instead
---@return string?
function M.color(name, bg)
  ---@type {foreground?: number, background?: number}?
  local hl = vim.api.nvim_get_hl and vim.api.nvim_get_hl(0, { name = name, link = false })
    or vim.api.nvim_get_hl_by_name(name, true)

  ---@diagnostic disable-next-line: undefined-field
  local color = nil
  if hl then
    -- nvim_get_hl returns integer keys; nvim_get_hl_by_name uses "foreground"/"background"
    color = bg and (hl.bg or hl.background) or (hl.fg or hl.foreground)
  end
  return color and string.format("#%06x", color) or nil
end

-- ============================================================================
-- copy_reference — copy a PHP class::method reference to the clipboard
-- Builds a fully-qualified reference string for the method or property under
-- the cursor, in the format used by PHPUnit and Symfony:
--
--   App\Service\UserService::login
--   App\Entity\User::$email
--
-- Works by querying the treesitter AST for the namespace and class name in
-- the current buffer, then appending the word under the cursor.
--
-- Exposed as the :PHPCopyReference command and mapped to <leader>ccm.
-- ============================================================================

--- Build the FQCN::member reference string for the symbol under the cursor.
--- Prints an error and returns nil when called outside a PHP buffer.
---@return string?
function M.copy_reference()
  if vim.bo.filetype ~= "php" then
    print("Not a PHP file")
    return
  end

  -- Capture the namespace name and the class name from the AST.
  -- The order of captures determines the order they appear in the reference.
  local query_str = [[
      (namespace_definition (namespace_name) @capture)
      (class_declaration    (name)           @capture)
  ]]

  local bufnr  = vim.api.nvim_get_current_buf()
  local parser = vim.treesitter.get_parser(bufnr)
  local tree   = parser:parse()[1]
  local root   = tree:root()

  local reference = ""
  local query = vim.treesitter.query.parse(vim.bo.filetype, query_str)

  for _, node in query:iter_captures(root, bufnr) do
    if node then
      reference = reference .. vim.treesitter.get_node_text(node, bufnr)

      -- After the namespace, insert the PHP namespace separator
      if node:type() == "namespace_name" then
        reference = reference .. "\\"
      -- After the class name, insert the static member separator
      elseif node:type() == "name" then
        reference = reference .. "::"
      end
    end
  end

  -- Append the word under the cursor, which should be the method/property name
  reference = reference .. vim.fn.expand("<cword>")
  print("Yanked reference: " .. reference)

  return reference
end

-- :PHPCopyReference writes the reference to both the system clipboard (+)
-- and the unnamed register (") so it works even when + is unavailable.
vim.api.nvim_create_user_command("PHPCopyReference", function()
  local reference = M.copy_reference()
  vim.fn.setreg("+", reference)
  vim.fn.setreg('"', reference)
end, { desc = "Copy current PHP method/property reference to clipboard" })

vim.keymap.set("n", "<leader>ccm", "<cmd>PHPCopyReference<cr>", { desc = "Copy method/property reference" })

return M
