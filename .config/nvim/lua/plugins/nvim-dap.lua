---@diagnostic disable: missing-fields
-- nvim-dap — Debug Adapter Protocol client
-- Provides a common interface to language-specific debug adapters.
-- The UI (nvim-dap-ui) opens automatically when a session starts and
-- closes when the session ends.
--
-- Supported adapters:
--   PHP  vscode-php-debug (node-based, at ~/lsp/vscode-php-debug/)
--          Two launch configs:
--          - Listen for Xdebug in a Docker container (port 9003, host 0.0.0.0)
--            Path mapping: /app → vim's cwd (assumes nvim is opened at project root)
--          - Listen for Xdebug directly (port 9003, no path mapping)
--   Go   nvim-dap-go (automatic adapter configuration)
--
-- Required Xdebug PHP ini settings (php.ini / docker env):
--   xdebug.mode=debug
--   xdebug.start_with_request=yes
--   xdebug.client_host=host.docker.internal   (containers on local machine)
--   xdebug.client_host=<remote IP>            (containers on a remote machine)
--
-- UI layout:
--   Left panel  (width 50): Scopes (50 %) + Call Stack (50 %)
--   Bottom panel (height 10): REPL
--
-- Keymaps:
--   <F1>          step into
--   <F2>          step over
--   <F3>          step out
--   <F5>          start / continue
--   <F6>          disconnect
--   <F7>          toggle DAP UI
--   <leader>cb    toggle breakpoint on current line
--   <leader>cB    set a conditional breakpoint (prompts for expression)
return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",       -- graphical panels (scopes, stacks, REPL)
    "nvim-neotest/nvim-nio",      -- async I/O library required by nvim-dap-ui
    "leoluz/nvim-dap-go",         -- Go adapter (wraps Delve)
  },
  config = function()
    local dap   = require("dap")
    local dapui = require("dapui")

    -- Configure the Go adapter via nvim-dap-go
    require("dap-go").setup({})

    -- DAP UI layout
    dapui.setup({
      layouts = {
        {
          -- Left panel: variable scopes above, call stack below
          position = "left",
          size     = 50,
          elements = {
            { id = "scopes", size = 0.50 },
            { id = "stacks", size = 0.50 },
          },
        },
        {
          -- Bottom panel: interactive REPL for evaluating expressions
          position = "bottom",
          size     = 10,
          elements = {
            { id = "repl", size = 1 },
          },
        },
      },
    })

    -- Keymaps
    vim.keymap.set("n", "<F5>",       dap.continue,       { desc = "Debug: Start/Continue" })
    vim.keymap.set("n", "<F6>",       dap.disconnect,     { desc = "Debug: Disconnect" })
    vim.keymap.set("n", "<F1>",       dap.step_into,      { desc = "Debug: Step Into" })
    vim.keymap.set("n", "<F2>",       dap.step_over,      { desc = "Debug: Step Over" })
    vim.keymap.set("n", "<F3>",       dap.step_out,       { desc = "Debug: Step Out" })
    vim.keymap.set("n", "<F7>",       dapui.toggle,       { desc = "Debug: Toggle UI" })
    vim.keymap.set("n", "<leader>cb", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
    vim.keymap.set("n", "<leader>cB", function()
      dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, { desc = "Debug: Set Conditional Breakpoint" })

    -- Open the UI automatically when a session initialises; close it on exit.
    -- The terminated event is intentionally not wired so the UI stays open
    -- after the program ends, allowing inspection of the final state.
    dap.listeners.after.event_initialized["dapui_config"] = dapui.open
    dap.listeners.before.event_exited["dapui_config"]     = dapui.close

    -- -----------------------------------------------------------------------
    -- PHP adapter — vscode-php-debug (node-based)
    -- -----------------------------------------------------------------------
    dap.adapters.php = {
      type    = "executable",
      command = "node",
      args    = { vim.fn.expand("~/lsp/vscode-php-debug/out/phpDebug.js") },
    }

    dap.configurations.php = {
      {
        -- Attach to an Xdebug session coming from inside a Docker container.
        -- The path mapping translates container paths (/app) to the host path
        -- where nvim is running (assumes cwd == project root).
        type    = "php",
        request = "launch",
        name    = "[nvim] Listen for Xdebug in Docker container",
        port    = 9003,
        hostname = "0.0.0.0",  -- listen on all interfaces so Docker can reach it
        pathMappings = {
          ["/app"] = vim.uv.cwd(),  -- container path → host path
        },
      },
      {
        -- Attach to a local Xdebug session (no Docker, no path mapping needed).
        type    = "php",
        request = "launch",
        name    = "[nvim] Listen for Xdebug",
        port    = 9003,
      },
    }
  end,
}
