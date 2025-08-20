return {
  "rcarriga/nvim-dap-ui",
  dependencies = {
    "mfussenegger/nvim-dap",
    "nvim-neotest/nvim-nio",
    "theHamsta/nvim-dap-virtual-text",

    -- Installs the debug adapters for you
    "williamboman/mason.nvim",
    "jay-babu/mason-nvim-dap.nvim",

    -- Add your own debuggers here
    "leoluz/nvim-dap-go",
  },
  config = function()
    local dap = require("dap")
    local ui = require("dapui")
    require("nvim-dap-virtual-text").setup({})

    require("mason-nvim-dap").setup({
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_setup = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        "dlv",
      },
    })

    -- Basic debugging keymaps, feel free to change to your liking!
    Map("n", "<F1>", dap.continue, { desc = "Start/Continue" })
    Map("n", "<F2>", dap.step_into, { desc = "Step Into" })
    Map("n", "<F3>", dap.step_over, { desc = "Step Over" })
    Map("n", "<F4>", dap.step_out, { desc = "Step Out" })
    Map("n", "<F5>", dap.step_back, { desc = "Step Back" })
    Map("n", "<F6>", dap.restart, { desc = "Restart" })
    Map("n", "<F7>", dap.terminate, { desc = "Stop" })
    -- toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    Map("n", "<F8>", ui.toggle)
    Map("n", "gb", dap.run_to_cursor)
    Map("n", "<leader>b", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
    Map("n", "<leader>B", function()
      dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, { desc = "Set Breakpoint Condition" })

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    ui.setup({})

    dap.listeners.before.attach.dapui_config = ui.open
    dap.listeners.before.launch.dapui_config = ui.open
    dap.listeners.before.event_terminated.dapui_config = ui.close
    dap.listeners.before.event_exited.dapui_config = ui.close

    -- Install golang specific config
    require("dap-go").setup()

    dap.adapters.python = {
      type = "executable",
      command = "python",
      args = { "-m", "debugpy.adapter" },
    }

    dap.configurations.python = {
      {
        type = "python",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        pythonPath = function()
          return "/usr/bin/python"
        end,
      },
    }
  end,
}
