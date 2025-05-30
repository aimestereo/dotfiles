-- [[ Highlight on yank ]]
-- See `:help vim.hl.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.hl.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

-- Options through Telescope
vim.api.nvim_set_keymap(
  "n",
  "<Leader><tab>",
  "<Cmd>lua require('telescope.builtin').commands()<CR>",
  { noremap = false }
)
