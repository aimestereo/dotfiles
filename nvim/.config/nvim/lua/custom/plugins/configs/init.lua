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
  "theprimeagen/harpoon",
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

  -- LLM
  "David-Kunz/gen.nvim",

  -- Git related plugins
  "tpope/vim-fugitive",
  "lewis6991/gitsigns.nvim",
  "ThePrimeagen/git-worktree.nvim",

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
