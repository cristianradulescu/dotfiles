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
        bashls = {
          cmd = { vim.fn.expand("~/lsp/bashls/node_modules/.bin/bash-language-server"), "start" },
        },
        lua_ls = {
          cmd = { vim.fn.expand("~/lsp/lua-language-server/bin/lua-language-server") },
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME,
                },
              },
              telemetry = { enabled = false },
              format = { enable = false },
            },
          },
        },
        twiggy_language_server = {
          cmd = { vim.fn.expand("~/lsp/twiggy-language-server/node_modules/.bin/twiggy-language-server"), "--stdio" },
        },
        docker_compose_language_service = {
          cmd = {
            vim.fn.expand("~/lsp/compose-language-service/node_modules/.bin/docker-compose-langserver"),
            "--stdio",
          },
        },
        docker_language_server = {},
        sqlls = {
          cmd = {
            vim.fn.expand("~/lsp/sql-language-server/node_modules/.bin/sql-language-server"),
            "up",
            "--method",
            "stdio",
          },
        },
        -- ts_ls = {}, --replace with tsgo?
        tsgo = {
          cmd = { vim.fn.expand("~/lsp/tsgo/node_modules/.bin/tsgo"), "--lsp", "--stdio" },
        },
        yamlls = {
          cmd = { vim.fn.expand("~/lsp/yaml-language-server/bin/yaml-language-server"), "--stdio" },
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
          cmd = {
            vim.fn.expand("~/lsp/vscode-langservers-extracted/node_modules/.bin/vscode-json-language-server"),
            "--stdio",
          },
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
        lemminx = {
          cmd = { vim.fn.expand("~/lsp/lemminx/lemminx-linux") },
        },
        gopls = {},
      }

      if vim.g.php_lsp == "intelephense" then
        servers = vim.tbl_extend("keep", servers, {
          intelephense = {
            cmp = { vim.fn.expand("~/lsp/intelephense/node_modules/intelephense/lib/intelephense.js"), "--stdio" },
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
            cmd = { "php", vim.fn.expand("~/lsp/phpactor/bin/phpactor"), "language-server" },
          },
        })
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
