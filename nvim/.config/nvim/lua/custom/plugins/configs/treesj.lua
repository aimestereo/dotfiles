return {
  -- splitting/joining blocks of code like arrays, hashes, statements, objects, dictionaries, etc.
  "Wansmer/treesj",
  event = "VeryLazy",
  -- keys = { "<space>m", "<space>j", "<space>s" },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    local treesj = require("treesj")

    treesj.setup({ --[[ your config ]]
      use_default_keymaps = false, -- only need one key
    })

    -- For use default preset and it work with dot
    vim.keymap.set("n", "<leader>m", treesj.toggle)
    -- For extending default preset with `recursive = true`, but this doesn't work with dot
    vim.keymap.set("n", "<leader>M", function()
      treesj.toggle({ split = { recursive = true } })
    end)
  end,
}
