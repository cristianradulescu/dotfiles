local M = {}

function M.oldfiles(picker, picker_func, picker_func_params)
  vim.keymap.set("n", "<leader>?", function()
    picker[picker_func](picker_func_params)
  end, { desc = "Find recently opened files" })
end

function M.buffers(picker, picker_func, picker_func_params)
  vim.keymap.set("n", "<leader><leader>", function()
    picker[picker_func](picker_func_params)
  end, { desc = "Buffers" })
end

function M.lines(picker, picker_func, picker_func_params)
  vim.keymap.set("n", "<leader>/", function()
    picker[picker_func](picker_func_params)
  end, { desc = "Fuzzily search in current buffer" })
end

function M.files(picker, picker_func, picker_func_params)
  vim.keymap.set("n", "<leader>sf", function()
    picker[picker_func](picker_func_params)
  end, { desc = "Search file" })
end

function M.marks(picker, picker_func, picker_func_params)
  vim.keymap.set("n", "<leader>sm", function()
    picker[picker_func](picker_func_params)
  end, { desc = "Search marks" })
end

function M.help(picker, picker_func, picker_func_params)
  vim.keymap.set("n", "<leader>sh", function()
    picker[picker_func](picker_func_params)
  end, { desc = "Search help" })
end

function M.keymaps(picker, picker_func, picker_func_params)
  vim.keymap.set("n", "<leader>sk", function()
    picker[picker_func](picker_func_params)
  end, { desc = "Search keymaps" })
end

function M.search_cword(picker, picker_func, picker_func_params)
  vim.keymap.set({ "n", "x" }, "<leader>sw", function()
    picker[picker_func](picker_func_params)
  end, { desc = "Search current word" })
end

function M.search_word(picker, picker_func, picker_func_params)
  vim.keymap.set("n", "<leader>sg", function()
    picker[picker_func](picker_func_params)
  end, { desc = "Search by grep" })
end

function M.search_diagnostics(picker, picker_func, picker_func_params)
  vim.keymap.set("n", "<leader>sd", function()
    picker[picker_func](picker_func_params)
  end, { desc = "Search diagnostics" })
end

function M.search_resume(picker, picker_func, picker_func_params)
  vim.keymap.set("n", "<leader>sr", function()
    picker[picker_func](picker_func_params)
  end, { desc = "Search resume" })
end

function M.search_document_symbols(picker, picker_func, picker_func_params)
  vim.keymap.set("n", "<leader>ss", function()
    picker[picker_func](picker_func_params)
  end, { desc = "Search symbols" })
end

function M.search_workspace_symbols(picker, picker_func, picker_func_params)
  vim.keymap.set("n", "<leader>sc", function()
    picker[picker_func](picker_func_params)
  end, { desc = "Search workspace symbols" })
end

function M.goto_definition(picker, picker_func, picker_func_params)
  vim.keymap.set("n", "gd", function()
    picker[picker_func](picker_func_params)
  end, { desc = "Goto definition" })
end

function M.goto_references(picker, picker_func, picker_func_params)
  vim.keymap.set("n", "gr", function()
    picker[picker_func](picker_func_params)
  end, { desc = "Goto references" })
end

function M.goto_implementation(picker, picker_func, picker_func_params)
  vim.keymap.set("n", "gI", function()
    picker[picker_func](picker_func_params)
  end, { desc = "Goto implementation" })
end

function M.goto_typedef(picker, picker_func, picker_func_params)
  vim.keymap.set("n", "<leader>D", function()
    picker[picker_func](picker_func_params)
  end, { desc = "Type definition" })
end

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
