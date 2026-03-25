-- fzf-lua — fuzzy finder for files, buffers, grep, LSP, and more
-- Active when vim.g.picker == "FzfLua" (set in options.lua).
-- The alternative picker is Snacks (see snacks.lua.disabled).
--
-- All picker keymaps are registered through user.keymaps-picker so that the
-- same logical bindings work regardless of which picker backend is active.
-- The only fzf-lua-specific keymap added here is <leader>sw (grep visual
-- selection), which has no picker-agnostic abstraction.
--
-- ui_select overrides vim.ui.select so that code actions and other
-- select prompts also use fzf-lua's floating window.
return {
  "ibhagwan/fzf-lua",
  cond = function()
    return vim.g.picker == "FzfLua"
  end,
  opts = {
    -- Recent files: hide the preview panel (speeds up the picker) and limit
    -- results to files under the current working directory.
    oldfiles = {
      winopts = { preview = { hidden = true } },
      cwd_only = true,
    },

    -- File picker: hide preview by default; show full relative paths.
    files = {
      winopts      = { preview = { hidden = true } },
      path_shorten = false,
    },

    -- Buffer picker: hide preview and restrict to the current project.
    buffers = {
      winopts  = { preview = { hidden = true } },
      cwd_only = true,
    },

    -- Grep: use a vertical split layout so the preview window has more height.
    -- Case-insensitive by default (mirrors vim's ignorecase option).
    -- Show line and column numbers in the preview (mirrors vim's number and relativenumber options).
    grep = {
      winopts  = { preview = { layout = "vertical" } },
      rg_opts  = "--ignore-case --column --line-number",
    },

    -- Diagnostics: vertical layout to see the full diagnostic message.
    diagnostics = {
      winopts = { preview = { layout = "vertical" } },
    },

    -- LSP pickers: vertical layout for definitions/references/implementations.
    -- Code actions use the `delta` pager for syntax-highlighted diffs when
    -- delta is installed; falls back to the default previewer otherwise.
    lsp = {
      winopts = { preview = { layout = "vertical" } },
      code_actions = {
        previewer = vim.fn.executable("delta") == 1 and "codeaction_native" or nil,
      },
    },

    -- Replace vim.ui.select with fzf-lua for all generic select prompts.
    -- Code-action prompts get a taller window with a diff preview pane;
    -- all other prompts get a compact window sized to the number of items.
    ui_select = function(fzf_opts, items)
      return vim.tbl_deep_extend("force", fzf_opts, {
        prompt = " ",
        winopts = {
          title     = " " .. vim.trim((fzf_opts.prompt or "Select"):gsub("%s*:%s*$", "")) .. " ",
          title_pos = "center",
        },
      }, fzf_opts.kind == "codeaction" and {
        winopts = {
          layout = "vertical",
          -- Height: number of items + 4 rows of chrome + 16 rows for the
          -- preview pane, capped at 80 % of the screen.
          height  = math.floor(math.min(vim.o.lines * 0.8 - 16, #items + 4) + 0.5) + 16,
          width   = 0.5,
          preview = not vim.tbl_isempty(vim.lsp.get_clients({ bufnr = 0, name = "vtsls" }))
            and { layout = "vertical", vertical = "down:15,border-top", hidden = "hidden" }
            or  { layout = "vertical", vertical = "down:15,border-top" },
        },
      } or {
        winopts = {
          width  = 0.5,
          height = math.floor(math.min(vim.o.lines * 0.8, #items + 4) + 0.5),
        },
      })
    end,
  },

  config = function(_, opts)
    local fzflua = require("fzf-lua")
    fzflua.setup(opts)

    if vim.g.picker == "FzfLua" then
      -- Wire all picker-agnostic keymaps to their fzf-lua implementations
      local keymaps = require("user.keymaps-picker")
      keymaps.oldfiles(fzflua, "oldfiles", {})
      keymaps.buffers(fzflua, "buffers", {})
      keymaps.lines(fzflua, "lines", {})
      keymaps.files(fzflua, "files", {})
      keymaps.marks(fzflua, "marks", {})
      keymaps.help(fzflua, "helptags", {})
      keymaps.keymaps(fzflua, "keymaps", {})
      keymaps.search_cword(fzflua, "grep_cword", {})
      keymaps.search_word(fzflua, "grep", {})
      keymaps.search_diagnostics(fzflua, "diagnostics_document", {})
      keymaps.search_resume(fzflua, "resume", {})
      keymaps.search_document_symbols(fzflua, "lsp_document_symbols", {})
      keymaps.search_workspace_symbols(fzflua, "lsp_workspace_symbols", {})
      keymaps.goto_definition(fzflua, "lsp_definitions", {})
      keymaps.goto_references(fzflua, "lsp_references", {})
      keymaps.goto_implementation(fzflua, "lsp_implementations", {})
      keymaps.goto_typedef(fzflua, "lsp_typedefs", {})
      keymaps.code_action(fzflua, "lsp_code_actions", {})

      -- Grep the current visual selection (no picker-agnostic abstraction exists)
      vim.keymap.set("v", "<leader>sw", function()
        fzflua.grep_visual()
      end, { desc = "Search current selection" })
    end
  end,
}
