-- blink.cmp — fast Lua-native completion engine
-- Active when vim.g.cmp_engine == "blink" (set in options.lua).
-- The alternative engine is nvim-cmp (see nvim-cmp.lua).
--
-- After setup, LSP capabilities are broadcast to all servers via
-- vim.lsp.config("*", ...) so every server knows which completion
-- features the client supports (e.g. snippet insertion, resolve).

-- Register the markdown parser for blink's documentation popups so that
-- doc comments with markdown formatting are highlighted correctly.
vim.treesitter.language.register("markdown", "blink-cmp-documentation")

return {
  "saghen/blink.cmp",
  cond = function()
    return vim.g.cmp_engine == "blink"
  end,
  -- friendly-snippets provides a curated set of VSCode-style snippets for
  -- many languages, loaded automatically by blink's snippet source.
  dependencies = {
    -- GitHub Copilot completion source for blink.cmp
    {
      "giuxtaposition/blink-cmp-copilot",
      cond = function()
        return vim.g.copilot_enabled
      end,
    },
  },
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
        copilot = {
          name = "copilot",
          module = "blink-cmp-copilot",
          score_offset = 100,
          async = true,
        },
      },
      -- Enable copilot source when available (controlled by vim.g.copilot_enabled)
      default = function()
        local enabled_sources = { "lsp", "path", "snippets", "buffer" }
        if vim.g.copilot_enabled then
          enabled_sources = vim.tbl_deep_extend("force", enabled_sources, { "copilot" })
        end

        return enabled_sources
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
