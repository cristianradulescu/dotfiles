---@diagnostic disable: missing-fields
return {
  {
    -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
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

      if vim.g.php_lsp == "intelephense" then
        servers = vim.tbl_extend("keep", servers, {
          intelephense = {
            settings = {
              intelephense = {
                files = {
                  maxSize = 99000000, -- 99MB?
                },
              },
            },
          },
        })
      end

      if vim.g.php_lsp == "phpactor" then
        servers = vim.tbl_extend("keep", servers, {
          phpactor = {
            cmd = { "php", "/opt/phpactor-unstable/bin/phpactor", "language-server" },
          },
        })
      end

      -- Skip Lemminx on Linux arm64 due to no support
      local os_info = vim.loop.os_uname()["sysname"] .. " " .. vim.loop.os_uname()["machine"]
      if os_info ~= "Linux aarch64" then
        servers = vim.tbl_extend("keep", servers, { lemminx = {} })
      end

      for server_name, server_config in pairs(servers) do
        if server_config ~= nil then
          vim.lsp.config(server_name, server_config)
        end
        vim.lsp.enable(server_name)
      end
    end,
  },
}
