-- Register 'markdown' for autocompletion popups
vim.treesitter.language.register('markdown', 'blink-cmp-documentation')

return {
  "saghen/blink.cmp",
  cond = function()
    return vim.g.cmp_engine == "blink"
  end,
  dependencies = { "rafamadriz/friendly-snippets" },
  version = "1.*",
  config = function(_, opts)
    require("blink.cmp").setup(opts)
    vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities(nil, true) })
  end,
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    fuzzy = {
      implementation = "lua",
      -- Always prioritize exact matches at the top
      sorts = {
        "exact",
        -- Prioritize LSP (variables, functions, classes) over buffer text
        function(a, b)
          if a.source_id == b.source_id then
            return -- Same source, continue to next sort
          end
          -- LSP comes before buffer
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
      -- Force LSP to be queried even without trigger characters when manually invoked
      providers = {
        lsp = {
          min_keyword_length = 0, -- Allow LSP even with no characters typed
        },
      },
    },
    completion = {
      list = {
        -- Do not insert items while browsing the autocomplete menu
        selection = { preselect = true, auto_insert = false },
        -- max_items = 10,
      },
      documentation = {
        auto_show = true,
      },
      menu = {
        auto_show = function()
          return vim.g.copilot_enabled
        end,
        draw = {
          columns = {
            { "kind_icon" },
            { "label", "label_description", gap = 1 },
            { "kind" },
            { "source_name" },
          },
        },
      },
    },
    cmdline = { enabled = false },
  },
}
