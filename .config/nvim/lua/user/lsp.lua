vim.lsp.enable({ "lua_ls", "phpactor" })

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    -- if client:supports_method('textDocument/completion') then
    --   vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    -- end

    -- Command to format with LSP
    vim.api.nvim_buf_create_user_command(ev.buf, "LspFormat", function(_)
      if client:supports_method("textDocument/formatting") then
        vim.notify("[LSP][" .. client.name .. "] Formatting buffer nb: " .. ev.buf)
        vim.lsp.buf.format()
      else
        vim.notify("[LSP][" .. client.name .. "] Formatting not supported by LSP " .. client.name)
      end
    end, { desc = "Format current buffer with LSP" })
  end,
})

vim.diagnostic.config({
  virtual_lines = false,
  virtual_text = true,
  float = {
    source = true,
    header = "",
    prefix = function(_, i, total)
      if total > 1 then
        -- Show the number of diagnostics in the line
        return i .. "/" .. total .. ": ", ""
      end
      return "", ""
    end,
  },
})

vim.keymap.set({ "n", "v" }, "<leader>cF", "<cmd>:LspFormat<cr>", { desc = "Format current buffer with LSP" })
