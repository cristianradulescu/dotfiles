return {
  "nvim-telescope/telescope.nvim",
  opts = {
    defaults = {
      mappings = {
        i = {
          -- Search in all (hidden and ignored) files
          ["<a-a>"] = function()
            local action_state = require("telescope.actions.state")
            local line = action_state.get_current_line()
            LazyVim.telescope("find_files", { hidden = true, no_ignore = true, default_text = line })()
          end,
        },
      },
    },
  },
}
