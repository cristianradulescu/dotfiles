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
            local picker_prompt_title = picker.prompt_title

            local new_opts = {}
            local new_builtin_action = ""

            local opts_find_files_with_hidden_and_no_ignore = {
              hidden = true,
              no_ignore = true,
            }
            local opts_vimgrep_arguments_with_hidden_and_no_ignore = {
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

            -- LazyVim will force "git_files" if it detects a ".git" dir, so usually
            -- this is the picker that is triggered. When switching to all files I can
            -- also change the picker.
            if picker_prompt_title == "Git Files" or picker_prompt_title == "Find Files" then
              new_builtin_action = "find_files"
              new_opts = opts_find_files_with_hidden_and_no_ignore
            elseif picker_prompt_title == "Live Grep" then
              new_builtin_action = "live_grep"
              new_opts = opts_vimgrep_arguments_with_hidden_and_no_ignore
            elseif picker_prompt_title:sub(1, #"Find Word") == "Find Word" then
              new_builtin_action = "grep_string"
              new_opts = vim.tbl_extend("force", opts_vimgrep_arguments_with_hidden_and_no_ignore, {
                word_match = "-w",
                -- the prompt title will have the search term, will get it from there instead from the current line
                search = picker_prompt_title:match("Find Word %((.*)%)"),
              })
            end

            if new_builtin_action ~= "" then
              require("telescope.builtin")[new_builtin_action](
                vim.tbl_extend("force", new_opts, { default_text = line })
              )
            else
              print("Refresh not implemented for picker " .. picker.prompt_title)
            end
          end,
        },
      },
    },
  },
}
