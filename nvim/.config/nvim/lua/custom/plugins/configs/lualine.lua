return {
  -- Set lualine as statusline
  'nvim-lualine/lualine.nvim',
  -- See `:help lualine.txt`
  opts = {
    options = {
      icons_enabled = true,
      theme = 'catppuccin',
      component_separators = '|',
      section_separators = '',
    },
    sections = {
      lualine_a = {
        {
          'mode',
          fmt = function(str)
            return str:sub(1, 1)
          end,
        },
      },
      lualine_b = { 'branch', 'diagnostics' },
      --lualine_b = {'branch', 'diff', 'diagnostics'},
      lualine_c = {
        { 'filename', path = 1 },
      },
    },
  },
}
