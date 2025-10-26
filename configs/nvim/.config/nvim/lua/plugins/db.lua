return {
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      {
        "kristijanhusak/vim-dadbod-completion",
        ft = {
          "sql",
          -- "mysql",
          -- "plsql",
        },
        lazy = true,
      },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_execute_on_save = false
      -- vim.g.db_ui_disable_mappings = true
      -- default
      vim.g.db_ui_save_location = "~/.local/share/db_ui"
      vim.g.db_url = os.getenv("DBUI_URL")

      vim.g.db_ui_bind_param_pattern = ":\\w\\+"
      -- vim.g.db_ui_bind_param_pattern = "\\$\\d\\+"

      Map("n", "<leader>\\", "<CMD>DBUIToggle<CR>", { desc = "Toggle DBUI" })
      -- Save <leader>w in sql file
    end,
  },
}
