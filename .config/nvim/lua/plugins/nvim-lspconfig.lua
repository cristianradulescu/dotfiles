---@diagnostic disable: missing-fields
return {
  {
    -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { "williamboman/mason.nvim", config = true },
      { "williamboman/mason-lspconfig.nvim"  },
    },
    opts = {
      inlay_hints = {
        enabled = true,
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
              format = { enable = false },
            },
          },
        },
        twiggy_language_server = {},
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

      local cmp_engine_capabilities = function()
        if vim.g.cmp_engine == "blink" then
          return require("blink.cmp").get_lsp_capabilities(nil, true)
        end
        if vim.g.cmp_engine == "nvim-cmp" then
          return require("cmp_nvim_lsp").default_capabilities()
        end

        return {}
      end
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, cmp_engine_capabilities())

      -- Setup Mason
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(servers),
      })
      require("mason-lspconfig").setup({
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
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
    end,
  },
}
