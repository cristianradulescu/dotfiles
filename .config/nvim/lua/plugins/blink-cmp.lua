-- blink.cmp — fast Lua-native completion engine
--
-- After setup, LSP capabilities are broadcast to all servers via
-- vim.lsp.config("*", ...) so every server knows which completion
-- features the client supports (e.g. snippet insertion, resolve).

-- Register the markdown parser for blink's documentation popups so that
-- doc comments with markdown formatting are highlighted correctly.
vim.treesitter.language.register("markdown", "blink-cmp-documentation")

return {
  "saghen/blink.cmp",
  -- friendly-snippets provides a curated set of VSCode-style snippets for
  -- many languages, loaded automatically by blink's snippet source.
  version = "1.*",
  config = function(_, opts)
    require("blink.cmp").setup(opts)
    -- Merge blink's extended capabilities into the global LSP client config
    -- so all servers receive them without per-server configuration.
    vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities(nil, true) })
  end,
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    fuzzy = {
      -- Use the pure-Lua fuzzy matcher (no compiled native module required)
      implementation = "lua",
      sorts = {
        -- Always surface exact-string matches first
        "exact",
        -- Prioritise LSP items (variables, methods, classes) over plain
        -- buffer-word matches when both appear in the same list.
        function(a, b)
          if a.source_id == b.source_id then
            return -- same source: fall through to the next sort criterion
          end
          if a.source_id == "lsp" then
            return true
          end
          if b.source_id == "lsp" then
            return false
          end
        end,
        "score",
        "sort_text",
      },
    },

    sources = {
      providers = {
        lsp = {
          -- Show LSP completions even before a trigger character is typed,
          -- so that manually invoking completion (<C-Space>) always queries the LSP.
          min_keyword_length = 0,
        },
      },
      default = function()
        return { "lsp", "path", "snippets", "buffer" }
      end,
    },

    completion = {
      list = {
        -- Pre-select the first item but don't insert it automatically while
        -- browsing — the user must confirm explicitly with <C-y> or <CR>.
        selection = { preselect = true, auto_insert = false },
      },
      documentation = {
        -- Show the documentation popup alongside the completion menu
        auto_show = true,
      },
      menu = {
        auto_show = true,
        draw = {
          -- Column layout: icon | label + detail | kind label | source name
          columns = {
            { "kind_icon" },
            { "label", "label_description", gap = 1 },
            { "kind" },
            { "source_name" },
          },
        },
      },
    },

    -- Disable blink's cmdline completion; the built-in wildmenu is sufficient.
    cmdline = { enabled = false },
  },
}
