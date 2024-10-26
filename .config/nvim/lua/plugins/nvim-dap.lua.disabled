---@diagnostic disable: missing-fields

return {
  "mfussenegger/nvim-dap",
  dependencies = {
    -- Creates a beautiful debugger UI
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",

    -- Installs the debug adapters for you
    "williamboman/mason.nvim",
    "jay-babu/mason-nvim-dap.nvim",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    require("mason-nvim-dap").setup({
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
      },
    })

    -- Dap UI setup
    dapui.setup({
      icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
      controls = {
        icons = {
          pause = "⏸",
          play = "▶",
          step_into = "⏎",
          step_over = "⏭",
          step_out = "⏮",
          step_back = "b",
          run_last = "▶▶",
          terminate = "⏹",
          disconnect = "⏏",
        },
      },
    })

    vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
    vim.keymap.set("n", "<F1>", dap.step_into, { desc = "Debug: Step Into" })
    vim.keymap.set("n", "<F2>", dap.step_over, { desc = "Debug: Step Over" })
    vim.keymap.set("n", "<F3>", dap.step_out, { desc = "Debug: Step Out" })
    vim.keymap.set("n", "<leader>cb", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
    vim.keymap.set("n", "<leader>cB", function()
      dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, { desc = "Debug: Set Breakpoint" })
    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set("n", "<F7>", dapui.toggle, { desc = "Debug: See last session result." })

    dap.listeners.after.event_initialized["dapui_config"] = dapui.open
    dap.listeners.before.event_terminated["dapui_config"] = dapui.close
    dap.listeners.before.event_exited["dapui_config"] = dapui.close

    local path = require("mason-registry").get_package("php-debug-adapter"):get_install_path()
    dap.adapters.php = {
      type = "executable",
      command = "node",
      args = { path .. "/extension/out/phpDebug.js" },
    }

    dap.configurations.php = {
      {
        type = "php",
        request = "launch",
        name = "[nvim] Listen for Xdebug in Docker container",
        -- Port for Xdebug 3
        port = 9003,
        -- Hostname for container
        hostname = "0.0.0.0",
        -- "/app" -> project path in container
        -- vim.loop.cwd() -> project path in host machine (assume nvim cwd is set to project root)
        pathMappings = {
          ["/app"] = vim.loop.cwd(),
        },
      },
    }
  end,
}
