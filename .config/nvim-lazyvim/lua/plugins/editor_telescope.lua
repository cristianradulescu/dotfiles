return {
  "nvim-telescope/telescope.nvim",
  opts = {
    defaults = {
      mappings = {
        i = {
          -- Search in all (hidden and ignored) files
          ["<a-a>"] = function(prompt_bufnr)
            local action_state = require("telescope.actions.state")
            local line = action_state.get_current_line()
            local picker = action_state.get_current_picker(prompt_bufnr)

            local new_opts = {}
            local builtin_action = ""

            -- LazyVim will force "git_files" if it detects a ".git" dir, so usually
            -- this is the picker that is triggered. When switching to all files I can
            -- also change the picker.
            if picker.prompt_title == "Git Files" or picker.prompt_title == "Find Files" then
              builtin_action = "find_files"
              new_opts = {
                hidden = true,
                no_ignore = true,
              }
            elseif picker.prompt_title == "Live Grep" then
              builtin_action = "live_grep"
              new_opts = {
                vimgrep_arguments = {
                  "rg",
                  "--color=never",
                  "--no-heading",
                  "--with-filename",
                  "--line-number",
                  "--column",
                  "--smart-case",
                  "--no-ignore-vcs",
                  "--hidden",
                },
              }
            end

            if builtin_action ~= "" then
              require("telescope.builtin")[builtin_action](vim.tbl_extend("force", new_opts, { default_text = line }))
            else
              print("Refresh not implemented for picker " .. picker.prompt_title)
            end
          end,
        },
      },
    },
  },
}
