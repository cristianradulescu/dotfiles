---@diagnostic disable: missing-fields

return {
  "mfussenegger/nvim-dap",
  dependencies = {
    -- Creates a beautiful debugger UI
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "leoluz/nvim-dap-go",
  },
  config = function()
    local dap = require("dap")
    require("dap-go").setup({})
    local dapui = require("dapui")
    dapui.setup({
      layouts = {
        {
          elements = {
            {
              id = "scopes",
              size = 0.50,
            },
            {
              id = "stacks",
              size = 0.50,
            },
          },
          position = "left",
          size = 50,
        },
        {
          elements = {
            {
              id = "repl",
              size = 1,
            },
            -- {
            --   id = "console",
            --   size = 0.5,
            -- },
          },
          position = "bottom",
          size = 10,
        },
      },
    })

    vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
    vim.keymap.set("n", "<F6>", dap.disconnect, { desc = "Debug: Disconnect" })
    vim.keymap.set("n", "<F1>", dap.step_into, { desc = "Debug: Step Into" })
    vim.keymap.set("n", "<F2>", dap.step_over, { desc = "Debug: Step Over" })
    vim.keymap.set("n", "<F3>", dap.step_out, { desc = "Debug: Step Out" })
    vim.keymap.set("n", "<leader>cb", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
    vim.keymap.set("n", "<leader>cB", function()
      dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, { desc = "Debug: Set Breakpoint" })
    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set("n", "<F7>", dapui.toggle, { desc = "Debug toogle UI." })

    dap.listeners.after.event_initialized["dapui_config"] = dapui.open
    -- dap.listeners.before.event_terminated["dapui_config"] = dapui.close
    dap.listeners.before.event_exited["dapui_config"] = dapui.close

    if (not require("mason-registry").is_installed("php-debug-adapter")) then
      vim.cmd("MasonInstall php-debug-adapter")
    end
    local path = require("mason-core.installer.InstallLocation").global():package("php-debug-adapter")
    dap.adapters.php = {
      type = "executable",
      command = "node",
      args = { path .. "/extension/out/phpDebug.js" },
    }
    dap.configurations.php = {
      -- Listen for Xdebug in Docker container
      -- Configuration for XDebug in container:
      -- - xdebug.mode=debug
      -- - xdebug.start_with_request=yes
      -- When containers are on local machine:
      -- - xdebug.client_host=host.docker.internal
      -- When containers are on remote machine:
      -- - xdebug.client_host=<IP of the remote machine>
      {
        type = "php",
        request = "launch",
        name = "[nvim] Listen for Xdebug in Docker container",
        port = 9003,
        -- Hostname for container
        hostname = "0.0.0.0",
        -- "/app" -> project path in container
        -- vim.uv.cwd() -> project path in host machine (assume nvim cwd is set to project root)
        pathMappings = {
          ["/app"] = vim.uv.cwd(),
        },
      },
      {
        type = "php",
        request = "launch",
        name = "[nvim] Listen for Xdebug",
        port = 9003,
      },
    }
  end,
}
