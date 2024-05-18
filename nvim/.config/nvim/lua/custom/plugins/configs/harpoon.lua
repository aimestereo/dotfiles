return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local harpoon = require("harpoon")
      local Config = require("harpoon.config")

      -- REQUIRED
      harpoon:setup({
        settings = {
          save_on_toggle = true,
          sync_on_ui_close = true,
        },
      })
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
          wk.register({
            ["<leader>"] = {
              h = {
                [key] = {
                  name = name,
                },
              },
            },
          })
        end

        vim.keymap.set("n", prefix .. "i", function()
          harpoon:list(name):add()
        end, { desc = "[I]nsert" })

        vim.keymap.set("n", prefix .. "e", function()
          harpoon.ui:toggle_quick_menu(harpoon:list(name))
        end, { desc = "[E]xplore" })

        -- Set <space>ha..<space>hf be my shortcuts to moving to the files
        for idx, k in ipairs({ "a", "s", "d", "f" }) do
          vim.keymap.set("n", "<space>h" .. k, function()
            harpoon:list():select(idx)
          end, { desc = string.format("%d file", idx) })
        end
      end

      -- Lists
      add_list(Config.DEFAULT_LIST, nil)
      add_list("config", "c")
      add_list("tests", "t")
      add_list("views", "v")
      add_list("models", "m")
    end,
  },
}
