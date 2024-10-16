local M = {}

-- From LazyVim
function M.foldexpr()
  local buf = vim.api.nvim_get_current_buf()

  -- don't use treesitter folds for non-file buffers
  if vim.bo[buf].buftype ~= "" then
    return "0"
  end

  -- as long as we don't have a filetype, don't bother
  -- checking if treesitter is available (it won't)
  if vim.bo[buf].filetype == "" then
    return "0"
  end

  local ok = pcall(vim.treesitter.get_parser, buf)

  if ok then
    return vim.treesitter.foldexpr()
  end

  return "0"
end

-- From LazyVim
---@return {fg?:string}?
function M.fg(name)
  local color = M.color(name)
  return color and { fg = color } or nil
end

---@param name string
---@param bg? boolean
---@return string?
function M.color(name, bg)
  ---@type {foreground?:number}?
  local hl = vim.api.nvim_get_hl and vim.api.nvim_get_hl(0, { name = name, link = false })
    or vim.api.nvim_get_hl_by_name(name, true)
  ---@diagnostic disable-next-line: undefined-field
  ---@type string?
  local color = nil
  if hl then
    if bg then
      color = hl.bg or hl.background
    else
      color = hl.fg or hl.foreground
    end
  end
  return color and string.format("#%06x", color) or nil
end


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

vim.keymap.set({ "n" }, "<leader>ccm", "<cmd>PHPCopyMethodReference<cr>", { desc = "Copy method referece" })

return M
