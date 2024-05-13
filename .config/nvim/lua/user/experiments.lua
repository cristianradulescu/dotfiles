-- ---------------------------------------------------------------
-- EXPERIMENTS
-- Things that I might not use in the future, but are fun to build
-- ---------------------------------------------------------------

-- -------
-- KEYMAPS
-- -------

-- [PHP] add semicolon at the end of line
vim.keymap.set("i", "<A-;>", function()
  local buffnr = vim.api.nvim_get_current_buf()

  if vim.bo[buffnr].filetype == "php" then
    return "<esc><cmd>TSTextobjectGotoNextEnd @statement.outer<cr>A;"
  end

  return "<Ignore>"
end, { expr = true, desc = "Add endline semicolon for PHP files" })


-- ---------
-- FUNCTIONS
-- ---------
local M = {}

-- [PHP] For the method under the cursor, copy the clas FQCN and method name
-- Example: `App\Service\UserService::login`
function M.copy_method_reference()
  if (vim.bo.filetype ~= "php") then
    print("Not a PHP file")
    return
  end

  local query_str = [[
      (namespace_definition (namespace_name)@capture)
      (class_declaration (name)@capture)
  ]]

  -- This looks like the standard way to parse queries
  local parser = vim.treesitter.get_parser()
  local tree = parser:parse()[1]
  local tree_root = tree:root()

  local method_reference = ""
  local query = vim.treesitter.query.parse(vim.bo.filetype, query_str)
  for _, matches, _ in query:iter_matches(tree_root) do
    local node = matches[1]
    if (nil ~= node) then
      -- Concat the node text 
      method_reference = method_reference .. vim.treesitter.get_node_text(node, 0)

      -- After namespace add "\"
      if ("namespace_name" == node:type()) then
        method_reference = method_reference .. "\\"
      -- After class name add "::"
      elseif ("name" == node:type()) then
        method_reference = method_reference .. "::"
      end
    end
  end

  -- Append the word under cursor - should be the method name
  method_reference = method_reference .. vim.fn.expand("<cword>")
  print("Yanked method reference: " .. method_reference)

  return method_reference
end

vim.api.nvim_create_user_command("PHPCopyMethodReference", function()
  local method_reference = M.copy_method_reference()
  -- Use both registers in case "+" is not available
  vim.fn.setreg('+', method_reference)
  vim.fn.setreg('"', method_reference)
end, { desc = "Copy current PHP method reference" })

return M
