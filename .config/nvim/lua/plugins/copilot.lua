return {
  "github/copilot.vim",
  cond = function()
    return vim.g.copilot_enabled
  end,
}
