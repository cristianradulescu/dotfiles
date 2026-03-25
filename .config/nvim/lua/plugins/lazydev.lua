-- lazydev.nvim — LuaLS workspace integration for editing the Neovim config
-- Only active for Lua filetypes. Automatically adds the Neovim runtime, plugin
-- sources, and lazy.nvim type definitions to the LuaLS workspace libraries so
-- that `vim.*` APIs and plugin modules get full autocompletion and type hints.
--
-- The luv (vim.uv) type definitions are loaded on-demand when the text
-- "vim.uv" is present in the buffer, keeping startup lean.
return {
  "folke/lazydev.nvim",
  ft   = "lua",
  opts = {
    library = {
      -- Load libuv (vim.uv) type stubs only when vim.uv is referenced
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
  },
}
