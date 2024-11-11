return {
  "sindrets/diffview.nvim",
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    opts = {
      default_mappings = {
        ours = "o",
        theirs = "t",
        none = "0",
        both = "b",
        next = "n",
        prev = "p",
      },
    },
    init = function()
      -- override the following default highlight groups for ease of viewing of merge conflicts
      vim.cmd("highlight DiffAdd guibg = '#405d7e'")
      vim.cmd("highlight DiffText guibg = '#314753'")

      require("git-conflict").setup({
        {
          default_mappings = true, -- disable buffer local mapping created by this plugin
          default_commands = true, -- disable commands created by this plugin
          disable_diagnostics = true, -- This will disable the diagnostics in a buffer whilst it is conflicted
          list_opener = "copen", -- command or function to open the conflicts list
          highlights = { -- They must have background color, otherwise the default color will be used
            incoming = "DiffAdd",
            current = "DiffText",
          },
        },
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "GitConflictDetected",
        callback = function()
          vim.notify("Conflict detected in file " .. vim.api.nvim_buf_get_name(0))
          vim.cmd("LspStop")
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "GitConflictResolved",
        callback = function()
          vim.cmd("LspRestart")
        end,
      })
    end,
  },
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
    end,
  },
}
