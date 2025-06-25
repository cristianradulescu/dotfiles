-- Configures LuaLS for editing your Neovim config by lazily updating your workspace libraries
return {
  "folke/lazydev.nvim",
  ft = "lua",
  opts = {
    library = {
      -- Load luvit types when the `vim.uv` word is found
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      -- Load the wezterm types when the `wezterm` module is required
      { path = "wezterm-types", mods = { "wezterm" } },
    },
  },
  dependencies = {
    -- Required for `wezterm` module
    "justinsgithub/wezterm-types",
  },
}
