local harpoon = require("harpoon")
local Config = require("harpoon.config")

-- REQUIRED
harpoon:setup()
-- REQUIRED

local wk = require("which-key")
wk.register({
  ["<leader>"] = {
    h = {
      name = "[H]arpoon",
    },
  },
})

local harpoon_prefix = "<leader>h"

local function add_list(name, key)
  local prefix
  if key == nil then
    prefix = harpoon_prefix
  else
    prefix = harpoon_prefix .. key
    wk.register({ ["<leader>"] = {
      h = {
        [key] = {
          name = name,
        },
      },
    } })
  end

  vim.keymap.set("n", prefix .. "i", function()
    harpoon:list(name):add()
  end, { desc = "[I]nsert" })

  vim.keymap.set("n", prefix .. "e", function()
    harpoon.ui:toggle_quick_menu(harpoon:list(name))
  end, { desc = "[E]xplore" })

  -- Toggle previous & next buffers stored within list
  vim.keymap.set("n", prefix .. "p", function()
    harpoon:list(name):prev()
  end, { desc = "[P]revious" })

  vim.keymap.set("n", prefix .. "n", function()
    harpoon:list(name):next()
  end, { desc = "[N]ext" })

  -- Select files from Harpoon list
  vim.keymap.set("n", prefix .. "a", function()
    harpoon:list(name):select(1)
  end, { desc = "1st file" })

  vim.keymap.set("n", prefix .. "s", function()
    harpoon:list(name):select(2)
  end, { desc = "2nd file" })

  vim.keymap.set("n", prefix .. "d", function()
    harpoon:list(name):select(3)
  end, { desc = "3rd file" })

  vim.keymap.set("n", prefix .. "f", function()
    harpoon:list(name):select(4)
  end, { desc = "4th file" })
end

-- Lists
add_list(Config.DEFAULT_LIST, nil)
add_list("config", "c")
add_list("tests", "t")
add_list("views", "v")
add_list("models", "m")
