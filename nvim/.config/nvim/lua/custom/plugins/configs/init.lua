return {

  "nvim-lua/plenary.nvim", -- lua functions that many plugins use

  -- Navigation
  { "kevinhwang91/nvim-bqf", event = "VeryLazy" },
  "christoomey/vim-tmux-navigator", -- tmux & split window navigation

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
