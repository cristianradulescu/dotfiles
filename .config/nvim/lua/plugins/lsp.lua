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
    },
    opts = {
      inlay_hints = {
        enabled = true,
        -- exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
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
        marksman = {},
        sqlls = {},
        ts_ls = {},
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

      -- Skip Lemminx on Linux arm64 due to no support
      local os_info = vim.loop.os_uname()["sysname"] .. " " .. vim.loop.os_uname()["machine"]
      if os_info ~= "Linux aarch64" then
        servers = vim.tbl_extend("keep", servers, { lemminx = {} })
      end

      -- Setup neovim lua config
      require("neodev").setup()

      local on_attach = function(_, buffnr)
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

        nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
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
          vim.fn.expand("/opt/phpactor-unstable/bin/phpactor"),
          "language-server",
          -- "-vvv"
        },
        capabilities = vim.tbl_deep_extend("force", {}, capabilities, require("lspconfig").phpactor.capabilities or {}),
        on_attach = on_attach,
      })

      -- Gopls setup is buggy on WSL & Linux arm64, works better if installed from OS package manager
      require("lspconfig").gopls.setup({
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
            },
            staticcheck = true,
            gofumpt = true,
          },
        },
      })

      vim.diagnostic.config({
        virtual_lines = false,
        virtual_text = true,
        float = {
          source = true,
          header = "",
          prefix = function(_, i, total)
            if total > 1 then
              -- Show the number of diagnostics in the line
              return i .. "/" .. total .. ": ", ""
            end
            return "", ""
          end,
        },
      })
    end,
  },
}
