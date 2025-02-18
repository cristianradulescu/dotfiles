vim.filetype.add({
  filename = {
    [".env"] = "bash",
  },
  pattern = {
    [".env.*"] = "bash",
  }
})
