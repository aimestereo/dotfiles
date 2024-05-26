return {
  {
    "tpope/vim-fugitive",
    config = function()
      Map("n", "<leader>gb", ":Telescope git_branches<CR>")
      Map("n", "<leader>gB", ":Git blame<CR>")
      Map("n", "<A-g>", ":0G<cr>", { desc = "Open [G]it fugitive in current pane." })
    end,
  },
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
    init = function()
      require("telescope").load_extension("lazygit")
      -- autocmd BufEnter * :lua require('lazygit.utils').project_root_dir()
    end,
  },
  -- {
  --   "NeogitOrg/neogit",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim", -- required
  --     "sindrets/diffview.nvim", -- optional - Diff integration
  --     "nvim-telescope/telescope.nvim", -- optional
  --   },
  --   config = function()
  --     local neogit = require("neogit")
  --     neogit.setup({
  --       status = {
  --         recent_commit_count = 50,
  --       },
  --     })
  --
  --     Map("n", "<leader>gs", function()
  --       neogit.open({ kind = "replace" })
  --     end, { desc = "Neogit status" })
  --
  --     Map("n", "<leader>gc", ":Neogit commit<CR>")
  --     Map("n", "<leader>gp", ":Neogit pull<CR>")
  --     Map("n", "<leader>gP", ":Neogit push<CR>")
  --   end,
  -- },
}
