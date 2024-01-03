return {
  -- splitting/joining blocks of code like arrays, hashes, statements, objects, dictionaries, etc.
  "Wansmer/treesj",
  event = "VeryLazy",
  keys = { "<space>m" }, -- only hotkey for toggle
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("treesj").setup({ --[[ your config ]]
    })
  end,
}
