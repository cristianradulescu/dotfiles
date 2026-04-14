-- Treesitter — syntax parsing, highlighting, and navigation
-- Three plugins work together here:
--
--   nvim-treesitter              parser/query management + indentexpr helper
--   nvim-treesitter-textobjects  syntax-aware text object select/move helpers
--   nvim-treesitter-context      sticky context line at the top of the window
--                                showing the function/class the cursor is inside
--
-- Parsers guaranteed to be installed: php, json, bash, lua, markdown,
-- markdown_inline. All other parsers are installed automatically the first
-- time a file of that type is opened.
--
-- Text object keymaps (visual / operator-pending):
--   aa / ia   around / inner function argument
--   af / if   around / inner function
--   ac / ic   around / inner class
--
-- Runtime behavior:
--   - nvim-treesitter itself is loaded at startup (lazy = false), per upstream
--     recommendation for the main-branch rewrite.
--   - On every FileType event we:
--       1) map filetype -> treesitter language
--       2) install that parser on first use (if available and not installed)
--       3) start treesitter highlighting for the buffer
--       4) set indentexpr to nvim-treesitter's indent helper
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
      },
    },
    -- Re-compile changed parsers after a plugin update
    build = ":TSUpdate",
    config = function()
      local treesitter = require("nvim-treesitter")

      -- Setup only configures install/query location for main-branch TS.
      -- Features (highlight/fold/indent) are enabled separately per-buffer.
      treesitter.setup({})

      -- Parsers we always want present, installed asynchronously.
      local ensure_installed = { "php", "json", "bash", "lua", "markdown", "markdown_inline" }
      treesitter.install(ensure_installed)

      -- Cache available/installed parser names so FileType callback can stay
      -- cheap and avoid duplicate install requests.
      local available = {}
      for _, lang in ipairs(treesitter.get_available()) do
        available[lang] = true
      end

      local installed = {}
      for _, lang in ipairs(treesitter.get_installed()) do
        installed[lang] = true
      end

      local function ensure_parser(lang)
        if not lang or not available[lang] or installed[lang] then
          return
        end
        installed[lang] = true
        treesitter.install(lang)
      end

      -- Main-branch replacement for old configs.setup({ auto_install = true,
      -- highlight = { enable = true }, indent = { enable = true } }).
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
        callback = function(args)
          local bufnr = args.buf
          local filetype = vim.bo[bufnr].filetype
          local lang = vim.treesitter.language.get_lang(filetype)

          ensure_parser(lang)

          pcall(vim.treesitter.start, bufnr, lang)
          vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })

      -- Textobjects moved out of nvim-treesitter core setup on main branch.
      -- Configure module behavior, then register explicit keymaps.
      local textobjects = require("nvim-treesitter-textobjects")
      local textobj_select = require("nvim-treesitter-textobjects.select")

      textobjects.setup({
        select = {
          lookahead = true,
        },
        move = {
          set_jumps = true,
        },
      })

      local textobj_keymaps = {
        aa = "@parameter.outer",
        ia = "@parameter.inner",
        af = "@function.outer",
        ["if"] = "@function.inner",
        ac = "@class.outer",
        ic = "@class.inner",
      }

      for lhs, query in pairs(textobj_keymaps) do
        vim.keymap.set({ "x", "o" }, lhs, function()
          textobj_select.select_textobject(query, "textobjects")
        end, { desc = "Treesitter textobject: " .. query })
      end
    end,
  },

  {
    -- Show the current function/class/block at the top of the window when the
    -- definition is scrolled out of view. Capped at 1 line to avoid obscuring
    -- code with multi-line signatures.
    "nvim-treesitter/nvim-treesitter-context",
    opts = {
      max_lines = 1,
    },
  },
}
