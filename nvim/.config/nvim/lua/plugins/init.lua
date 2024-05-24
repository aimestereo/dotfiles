return {
  "nvim-lua/plenary.nvim", -- lua functions that many plugins use

  -- Navigation
  "christoomey/vim-tmux-navigator", -- tmux & split window navigation

  { "numToStr/Comment.nvim", opts = {} }, -- "gc" to comment visual regions/lines
  "mg979/vim-visual-multi",
  "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically

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
