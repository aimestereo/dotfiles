return {
  "rcarriga/nvim-notify", -- Notification plugin used by noice.
  event = "VeryLazy",
  config = function()
    require("notify").setup({
      top_down = false,
      background_colour = "#000000",
    })
  end,
}
