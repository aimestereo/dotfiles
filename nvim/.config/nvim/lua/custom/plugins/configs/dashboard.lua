return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  config = function()
    local db = require("dashboard")
    db.setup({
      theme = "hyper",
      config = {
        week_header = {
          enable = true,
        },
        project = { enable = false },
        shortcut = {
          { desc = "󰊳 Update", group = "@property", action = "Lazy update", key = "u" },
          {
            icon = " ",
            icon_hl = "@variable",
            desc = "Files",
            group = "Label",
            action = "Telescope find_files",
            key = "f",
          },
          {
            desc = " Quit Dashboard",
            group = "DiagnosticHint",
            action = "lua vim.cmd.bdelete(); vim.cmd.startinsert()",
            key = "q",
          },
          -- {
          --   desc = " dotfiles",
          --   group = "Number",
          --   action = "Telescope dotfiles",
          --   key = "d",
          -- },
        },
      },
    })
  end,
  dependencies = { { "nvim-tree/nvim-web-devicons" } },
}
