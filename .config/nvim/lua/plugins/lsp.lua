---@diagnostic disable: missing-fields
return {
  {
    -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
    event = "BufReadPost",
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { "williamboman/mason.nvim", config = true },
      { "williamboman/mason-lspconfig.nvim" },

      -- Useful status updates for LSP
      { "j-hui/fidget.nvim", tag = "legacy", opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      "folke/neodev.nvim",

      -- Autocomplete
      {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        version = false,
        dependencies = {
          "hrsh7th/cmp-nvim-lsp",
          "hrsh7th/cmp-nvim-lsp-signature-help",
          "hrsh7th/cmp-path",
          "hrsh7th/cmp-nvim-lua",
          "hrsh7th/cmp-buffer",
          -- Snippet Engine & its associated nvim-cmp source
          {
            "L3MON4D3/LuaSnip",
            build = (function()
              -- Build Step is needed for regex support in snippets
              return "make install_jsregexp"
            end)(),
          },
          "saadparwaiz1/cmp_luasnip",
        },
      },
    },

    config = function()
      local servers = {
        bashls = {},
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              telemetry = { enabled = false },
            },
          },
        },
        twiggy_language_server = {},
        cssls = {},
        docker_compose_language_service = {},
        dockerls = {},
        html = {},
        lemminx = {},
        marksman = {},
        sqlls = {},
        ts_ls = {},
        gopls = {},
        yamlls = {
          -- Have to add this for yamlls to understand that we support line folding
          capabilities = {
            textDocument = {
              foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
              },
            },
          },
          -- lazy-load schemastore when needed
          on_new_config = function(new_config)
            new_config.settings.yaml.schemas = vim.tbl_deep_extend(
              "force",
              new_config.settings.yaml.schemas or {},
              require("schemastore").yaml.schemas()
            )
          end,
          settings = {
            redhat = { telemetry = { enabled = false } },
            yaml = {
              keyOrdering = false,
              format = {
                enable = true,
              },
              validate = true,
              schemaStore = {
                -- Must disable built-in schemaStore support to use
                -- schemas from SchemaStore.nvim plugin
                enable = false,
                -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                url = "",
              },
            },
          },
        },
        jsonls = {
          -- lazy-load schemastore when needed
          on_new_config = function(new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
          end,
          settings = {
            json = {
              format = {
                enable = true,
              },
              validate = { enable = true },
            },
          },
        },
      }

      -- Setup neovim lua config
      require("neodev").setup()

      local on_attach = function(_, buffnr)
        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
          border = "single",
        })

        vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
          border = "single",
          focusable = false,
          relative = "cursor",
          silent = true,
        })

        -- Create a command `:Format` local to the LSP buffer
        vim.api.nvim_buf_create_user_command(buffnr, "Format", function(_)
          vim.lsp.buf.format()
        end, { desc = "Format current buffer with LSP" })

        -- Create command to force Phpactor reindex
        vim.api.nvim_buf_create_user_command(buffnr, "PhpactorReindex", function(_)
          local clients = vim.lsp.get_clients({ name = "phpactor" })
          if next(clients) then
            vim.notify("LSP: Starting Phpactor reindexing")
            vim.lsp.buf_notify(0, "phpactor/indexer/reindex", {})
          else
            vim.notify("LSP: Cannot reindex, Phpactor not attached")
          end
        end, { desc = "Phpactor reindex" })

        -- Create a function that lets us more easily define mappings specific
        -- for LSP related items. It sets the mode, buffer and description for us each time.
        local nmap = function(keys, func, desc)
          if desc then
            desc = "LSP: " .. desc
          end

          vim.keymap.set("n", keys, func, { buffer = buffnr, desc = desc })
        end

        nmap("<leader>rn", vim.lsp.buf.rename, "Rename")
        nmap("<leader>ca", function()
          vim.lsp.buf.code_action({ context = { only = { "quickfix", "refactor", "source" } } })
        end, "Code Action")

        -- See `:help K` for why this keymap
        -- nmap("K", vim.lsp.buf.hover, "Hover Documentation") -- Built-in in v10
        nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

        -- nmap("<leader>cf", "<cmd>Format<cr>", "Format code") -- Replced with Conform
      end

      -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

      -- Setup Mason
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(servers),
      })
      require("mason-lspconfig").setup({
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for tsserver)
            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            server.on_attach = on_attach
            require("lspconfig")[server_name].setup(server)
          end,
        },
      })

      -- Use Phpactor from source since it has issues with stubs due to being installed as phar
      require("lspconfig").phpactor.setup({
        cmd = {
          "php",
          -- vim.fn.expand("$HOME/.local/share/nvim/lazy/phpactor/bin/phpactor"),
          vim.fn.expand("/opt/phpactor-unstable/bin/phpactor"),
          "language-server",
          -- "-vvv"
        },
        capabilities = vim.tbl_deep_extend("force", {}, capabilities, require("lspconfig").phpactor.capabilities or {}),
        on_attach = on_attach,
      })

      local cmp = require("cmp")
      local luasnip = require("luasnip")
      luasnip.config.setup({})

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "nvim-lsp-signature-help" },
          { name = "path" },
          { name = "nvim_lua" },
          { name = "calendar" },
        }, {
          { name = "buffer", max_item_count = 3 },
        }),

        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-c>"] = cmp.mapping.abort(),
          ["<C-y>"] = cmp.mapping.confirm({ select = true }),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),

          -- ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }),

        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
      })

      vim.diagnostic.config({
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      })
    end,
  },
}
