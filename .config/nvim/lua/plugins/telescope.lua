return {
  -- Fuzzy Finder (files, lsp, etc)
  {
    "nvim-telescope/telescope.nvim",
    version = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable "make" == 1
        end,
      },
    },

    config = function()
      require("telescope").setup({
        defaults = {
          layout_strategy = "vertical",
          layout_config = {
            vertical = {
              mirror = true,
              prompt_position = "top",
            },
            preview_cutoff = 0,
          },
          mappings = {
            i = {
              -- Leave this uncomment to be able to scroll up/down in Telescope preview
              -- ["<C-u>"] = false,
              -- ["<C-d>"] = false,

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

                -- By default I will search in not hidden and not ignored files. When switching to all files I can
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
        }
      })
      pcall(require("telescope").load_extension, "fzf")

      local telescope = require("telescope.builtin")
      vim.keymap.set('n', '<leader>?', function()
        require('telescope.builtin').oldfiles({ cwd_only = true })
      end, { desc = '[?] Find recently opened files' })

      vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[] Find existing buffers' })
      vim.keymap.set('n', '<leader>/', require('telescope.builtin').current_buffer_fuzzy_find, { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set("n", "<leader>sf", telescope.find_files, { desc = "[S]earch [F]iles" })
      vim.keymap.set("n", "<leader>sh", telescope.help_tags, { desc = "[S]earch [H]elp" })
      vim.keymap.set("n", "<leader>sk", telescope.keymaps, { desc = "[S]earch [K]eymaps" })
      vim.keymap.set("n", "<leader>sw", telescope.grep_string, { desc = "[S]earch current [W]ord" })
      vim.keymap.set("n", "<leader>sg", telescope.live_grep, { desc = "[S]earch by [G]rep" })
      vim.keymap.set("n", "<leader>sd", telescope.diagnostics, { desc = "[S]earch [D]iagnostics" })
      vim.keymap.set("n", "<leader>sr", telescope.resume, { desc = "[S]earch [R]esume" })
      vim.keymap.set("n", "<leader>ss", function()
        telescope.lsp_document_symbols({ symbol_width = 55 })
      end, { desc = "[S]earch [S]ymbols" })

      vim.keymap.set("n", "<leader>sc", telescope.lsp_dynamic_workspace_symbols,
        { desc = "Search Workspace Symbols" })
      vim.keymap.set("n", "gd", function()
        telescope.lsp_definitions({ fname_width = 75 })
      end, { desc = "[G]oto [D]efinition" })
      vim.keymap.set("n", "gr", function()
        -- TODO: add fname_width globally
        telescope.lsp_references({ fname_width = 75 })
      end, {
        desc =
        "[G]oto [R]eferences"
      })
      vim.keymap.set("n", "gI", function()
        telescope.lsp_implementations({ fname_width = 75 })
      end, { desc = "[G]oto [I]mplementation" })
      vim.keymap.set("n", "<leader>D", function()
        telescope.lsp_type_definitions({ fname_width = 75 })
      end, { desc = "Type [D]efinition" })
    end
  },

}
