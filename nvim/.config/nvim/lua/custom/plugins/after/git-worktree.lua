require('git-worktree').setup {
  --change_directory_command = <str> -- default: "cd",
  --update_on_change = <boolean> -- default: true,
  --update_on_change_command = <str> -- default: "e .",
  --clearjumps_on_change = <boolean> -- default: true,
  --autopush = <boolean> -- default: false,
}
require('telescope').load_extension 'git_worktree'

vim.keymap.set('n', '<leader>gwl', function()
  require('telescope').extensions.git_worktree.git_worktrees()
end, { desc = 'Telescope [G]it-[W]orktree [L]ist' })

vim.keymap.set('n', '<leader>gwc', function()
  require('telescope').extensions.git_worktree.create_git_worktree()
end, { desc = 'Telescope [G]it-[W]orktree [C]reate' })
