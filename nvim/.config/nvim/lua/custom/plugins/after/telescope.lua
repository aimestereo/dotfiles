-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
local telescope = require 'telescope'
local lga_actions = require 'telescope-live-grep-args.actions'
local telescope_actions = require 'telescope.actions'
telescope.setup {
  extensions = {
    live_grep_args = {
      auto_quoting = true, -- enable/disable auto-quoting
      -- define mappings, e.g.
      mappings = { -- extend mappings
        i = {
          ['<C-k>'] = lga_actions.quote_prompt(),
          ['<C-i>'] = lga_actions.quote_prompt { postfix = ' --iglob ' },
        },
      },
      -- ... also accepts theme settings, for example:
      -- theme = "dropdown", -- use dropdown theme
      -- theme = { }, -- use own theme spec
      -- layout_config = { mirror=true }, -- mirror preview pane
    },
  },
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--hidden',
    },
    file_ignore_patterns = {
      '.git',
      '^build/',
      '^dist/',
      '^sdist/',
      '%.lock',
    },
    mappings = {
      i = {
        ['<C-n>'] = telescope_actions.cycle_history_next,
        ['<C-p>'] = telescope_actions.cycle_history_prev,

        ['<C-j>'] = telescope_actions.move_selection_next,
        ['<C-k>'] = telescope_actions.move_selection_previous,

        ['<C-c>'] = telescope_actions.close,

        ['<Down>'] = telescope_actions.move_selection_next,
        ['<Up>'] = telescope_actions.move_selection_previous,

        ['<CR>'] = telescope_actions.select_default,
        ['<C-x>'] = telescope_actions.select_horizontal,
        ['<C-v>'] = telescope_actions.select_vertical,
        ['<C-t>'] = telescope_actions.select_tab,

        ['<C-u>'] = telescope_actions.preview_scrolling_up,
        ['<C-d>'] = telescope_actions.preview_scrolling_down,

        ['<M-u>'] = telescope_actions.results_scrolling_up,
        ['<M-d>'] = telescope_actions.results_scrolling_down,

        ['<PageUp>'] = telescope_actions.results_scrolling_up,
        ['<PageDown>'] = telescope_actions.results_scrolling_down,

        ['<Tab>'] = telescope_actions.toggle_selection + telescope_actions.move_selection_worse,
        ['<S-Tab>'] = telescope_actions.toggle_selection + telescope_actions.move_selection_better,
        ['<C-q>'] = telescope_actions.send_to_qflist + telescope_actions.open_qflist,
        ['<M-q>'] = telescope_actions.send_selected_to_qflist + telescope_actions.open_qflist,
        ['<C-l>'] = telescope_actions.complete_tag,
        ['<C-_>'] = telescope_actions.which_key, -- keys from pressing <C-/>
      },

      n = {
        ['<esc>'] = telescope_actions.close,
        ['<CR>'] = telescope_actions.select_default,
        ['<C-x>'] = telescope_actions.select_horizontal,
        ['<C-v>'] = telescope_actions.select_vertical,
        ['<C-t>'] = telescope_actions.select_tab,

        ['<Tab>'] = telescope_actions.toggle_selection + telescope_actions.move_selection_worse,
        ['<S-Tab>'] = telescope_actions.toggle_selection + telescope_actions.move_selection_better,
        ['<C-q>'] = telescope_actions.send_to_qflist + telescope_actions.open_qflist,
        ['<M-q>'] = telescope_actions.send_selected_to_qflist + telescope_actions.open_qflist,

        ['j'] = telescope_actions.move_selection_next,
        ['k'] = telescope_actions.move_selection_previous,
        ['H'] = telescope_actions.move_to_top,
        ['M'] = telescope_actions.move_to_middle,
        ['L'] = telescope_actions.move_to_bottom,

        ['<Down>'] = telescope_actions.move_selection_next,
        ['<Up>'] = telescope_actions.move_selection_previous,
        ['gg'] = telescope_actions.move_to_top,
        ['G'] = telescope_actions.move_to_bottom,

        ['<C-u>'] = telescope_actions.preview_scrolling_up,
        ['<C-d>'] = telescope_actions.preview_scrolling_down,

        ['<M-u>'] = telescope_actions.results_scrolling_up,
        ['<M-d>'] = telescope_actions.results_scrolling_down,

        ['<PageUp>'] = telescope_actions.results_scrolling_up,
        ['<PageDown>'] = telescope_actions.results_scrolling_down,

        ['?'] = telescope_actions.which_key,
      },
    },
  },
}

telescope.load_extension 'fzf'
telescope.load_extension 'live_grep_args'

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>sp', require('telescope.builtin').git_files, { desc = '[S]earch [P]roject files (Git Files)' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
--vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sg', ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>sp', require('telescope.builtin').git_files, { desc = '[S]earch [P]roject files (Git Files)' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
--vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sg', ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
