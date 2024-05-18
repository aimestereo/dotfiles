return {
  "ThePrimeagen/vim-be-good",

  "nvim-lua/plenary.nvim", -- lua functions that many plugins use

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
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
  },
  "onsails/lspkind.nvim",

  -- LLM
  "David-Kunz/gen.nvim",
  "github/copilot.vim",

  -- Git related plugins
  "tpope/vim-fugitive",
  "lewis6991/gitsigns.nvim",
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
