-- this one conflicts with cmp
--'Exafunction/codeium.vim', -- run after install :Codeium Auth
return {
  'jcdickinson/codeium.nvim', -- repo is archieved
  event = { 'BufReadPost', 'BufNewFile' },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'hrsh7th/nvim-cmp',
  },
  config = function()
    require('codeium').setup {}
  end,
}
