return {
  "kylechui/nvim-surround",
  event = { "BufReadPre", "BufNewFile" },
  version = "*",
  init = function()
    vim.g.nvim_surround_no_visual_mappings = true
  end,
  config = function()
    require("nvim-surround").setup({})
    vim.keymap.set("x", "gs", "<Plug>(nvim-surround-visual)")
  end,
}
