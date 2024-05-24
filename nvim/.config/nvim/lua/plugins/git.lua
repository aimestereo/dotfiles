return {
  "tpope/vim-fugitive",
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration
      "nvim-telescope/telescope.nvim", -- optional
    },
    config = function()
      local neogit = require("neogit")
      neogit.setup({
        status = {
          recent_commit_count = 50,
        },
      })

      Map("n", "<leader>gs", function()
        neogit.open({ kind = "replace" })
      end, { desc = "Neogit status" })

      Map("n", "<leader>gc", ":Neogit commit<CR>")
      Map("n", "<leader>gp", ":Neogit pull<CR>")
      Map("n", "<leader>gP", ":Neogit push<CR>")
      Map("n", "<leader>gb", ":Telescope git_branches<CR>")
      Map("n", "<leader>gB", ":Git blame<CR>")
    end,
  },
}
