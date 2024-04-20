-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  "ThePrimeagen/vim-be-good",

  "nvim-lua/plenary.nvim", -- lua functions that many plugins use

  {
    "rcarriga/nvim-notify", -- Notification plugin used by noice.
    event = "VeryLazy",
    opts = {
      top_down = false, -- Notifications start at the bottom to stay out of your way.
    },
  },

  -- Navigation
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  { "kevinhwang91/nvim-bqf", event = "VeryLazy" },
  "christoomey/vim-tmux-navigator", -- tmux & split window navigation
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip" },
  },
  "onsails/lspkind.nvim",

  -- LLM
  "David-Kunz/gen.nvim",
  -- "github/copilot.vim",
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "zbirenbaum/copilot.lua" },
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
      require("copilot_cmp").setup()
    end,
  },

  -- Git related plugins
  "tpope/vim-fugitive",
  "lewis6991/gitsigns.nvim",
  "ThePrimeagen/git-worktree.nvim",
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration
      "nvim-telescope/telescope.nvim", -- optional
    },
    config = true,
  },

  -- 'preservim/nerdcommenter'
  { "numToStr/Comment.nvim", opts = {} }, -- "gc" to comment visual regions/lines
  "mg979/vim-visual-multi",
  "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically

  { import = "custom.plugins.lsp" },

  -- Python
  {
    -- TODO: investigate how useful it is
    "ranelpadon/python-copy-reference.vim",
    config = function()
      vim.api.nvim_set_keymap("n", "<Space>rd", ":PythonCopyReferenceDotted<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<Space>rp", ":PythonCopyReferencePytest<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<Space>ri", ":PythonCopyReferenceImport<CR>", { noremap = true, silent = true })
    end,
  },
}
