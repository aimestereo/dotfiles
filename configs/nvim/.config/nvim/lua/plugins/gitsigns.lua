return {
  -- Adds git releated signs to the gutter, as well as utilities for managing changes
  "lewis6991/gitsigns.nvim",
  event = "VeryLazy",
  opts = {
    -- See `:help gitsigns.txt`
    signs = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
      show_trailing_blankline_indent = false,
    },

    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map("n", "g]c", function()
        if vim.wo.diff then
          return "g]c"
        end
        vim.schedule(function()
          gs.next_hunk()
        end)
        return "<Ignore>"
      end, { expr = true })

      map("n", "g[c", function()
        if vim.wo.diff then
          return "g[c"
        end
        vim.schedule(function()
          gs.prev_hunk()
        end)
        return "<Ignore>"
      end, { expr = true })

      -- Actions
      map("n", "<leader>ghs", gs.stage_hunk, { desc = "Stage hunk" })
      map("v", "<leader>ghs", function()
        gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "Stage hunk" })

      map("n", "<leader>ghr", gs.reset_hunk, { desc = "Reset hunk" })
      map("v", "<leader>ghr", function()
        gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "Reset hunk" })

      map("n", "<leader>ghu", gs.undo_stage_hunk, { desc = "Unstage hunk" })

      map("n", "<leader>ghp", gs.preview_hunk, { desc = "Preview hunk" })
      map("n", "<leader>gtb", gs.toggle_current_line_blame, { desc = "Toggle line blame" })
      map("n", "<leader>ghb", function()
        gs.blame_line({ full = true })
      end, { desc = "Blame hunk" })

      map("n", "<leader>ghd", function()
        vim.cmd("tabnew %")
        gs.diffthis()
      end, { desc = "Diff this against index" })
      map("n", "<leader>ghD", function()
        gs.diffthis("~")
      end, { desc = "Diff this" })
      map("n", "<leader>gtd", gs.toggle_deleted, { desc = "Toggle deleted" })

      -- Text object
      map({ "o", "x" }, "gih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk" })
    end,
  },
}
