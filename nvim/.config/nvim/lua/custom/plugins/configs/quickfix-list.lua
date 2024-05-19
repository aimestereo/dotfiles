return {
  {
    "kevinhwang91/nvim-bqf",
    event = "VeryLazy",
    config = function()
      -- Make Neovim's quickfix window better: preview, fzf, actions.
      require("bqf").setup({
        filter = {
          fzf = {
            extra_opts = { "--bind", "ctrl-o:toggle-all", "--delimiter", "│" },
          },
        },
      })
    end,
  },
}
