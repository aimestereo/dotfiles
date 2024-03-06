function Map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

--
-- Buffers
--
-- close current buffer without closing split (by moving first to previous buffer)
vim.keymap.set({ "n" }, "<A-x>", ":bp|bd #<cr>", { desc = "[C]lose current buffer" })
vim.keymap.set({ "n" }, "<A-s>", ":wa<cr>", { desc = "[S]ave all changed files" })
vim.keymap.set({ "i" }, "<A-s>", "<esc>:wa<cr>", { desc = "[S]ave all changed files" })
vim.keymap.set({ "n" }, "<A-g>", ":0G<cr>", { desc = "Open [G]it fugitive in current pane." })

--
-- Splits
--
--vim.keymap.set({ "n" }, "<A-w>", "<C-w>", { desc = "[W]indow (Splits) manager" })
--vim.keymap.set({ "n" }, "<A-w>", ":echo 'hi'", { desc = "[W]indow (Splits) manager" })
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "[W]indow (Splits) manager", noremap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "[W]indow (Splits) manager", noremap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "[W]indow (Splits) manager", noremap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "[W]indow (Splits) manager", noremap = true })

Map("n", "<C-Up>", ":resize +2<CR>", { desc = "Resize Window (Split)" })
Map("n", "<C-Down>", ":resize -2<CR>", { desc = "Resize Window (Split)" })
Map("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Resize Window (Split)" })
Map("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Resize Window (Split)" })

--
-- Helix or inspired by it
--
--vim.keymap.set('n', 'd', 'x', { desc = "Delete symbol under cursor" })
vim.keymap.set("n", "U", "<C-r>", { desc = "Redo (Reverse [U]ndo)" })
vim.keymap.set("v", "<A-;>", "o", { desc = "Flips selection." })

vim.keymap.set("n", "<A-c>", '"_cl', { desc = "[C]hange symbol/selection avoiding yank" })
vim.keymap.set("n", "<A-d>", '"_dl', { desc = "[D]elete symbol/selection avoiding yank" })
vim.keymap.set("v", "<A-c>", '"_c', { desc = "[C]hange symbol/selection avoiding yank" })
vim.keymap.set("v", "<A-d>", '"_d', { desc = "[D]elete symbol/selection avoiding yank" })

vim.keymap.set("x", "<A-p>", [["_dP]], { desc = "[P]aste without overwriting register" })
vim.keymap.set("v", "<leader>p", [["_d"+P]], { desc = "[P]aste clipboard without overwriting register" })

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "[Y]ank to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "[Y]ank current line to system clipboard" })

--
-- Refactor
--
vim.api.nvim_set_keymap(
  "n",
  "<leader>cw",
  [[<cmd>let @/='\<'.expand('<cword>').'\>'<cr>"_ciw]],
  { desc = "Rename word" }
)
vim.api.nvim_set_keymap(
  "x",
  "<leader>cw",
  [[y<cmd>let @/=substitute(escape(@", '/'), '\n', '\\n', 'g')<cr>"_cgn]],
  { desc = "Rename selected word" }
)

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

--
-- from ThePrimeagen: https://www.youtube.com/watch?v=w7i4amO_zaE&t=38s&ab_channel=ThePrimeagen
--
vim.keymap.set("n", "<C-e>", vim.cmd.Ex, { desc = "Open file [E]xplorer / vim folder view containing current file" })

-- Move selected line / block of text in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down in visual mode" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up in visual mode" })

-- Concatenate with next line and keep cursor at the same position
vim.keymap.set("n", "J", "mzJ`z", { desc = "Concatenate with next line and keep cursor at the same position" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll [d]own half-page and center cursor" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll [u]p half-page and center cursor" })

vim.keymap.set("n", "n", "nzzzv", { desc = "Go to a [n]ext match, keep cursor at the center of the screen" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Go to a previous match, keep cursor at the center of the screen" })

vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Esc" })
vim.keymap.set("n", "Q", "<nop>", { desc = "Silence Q" })

vim.keymap.set(
  "n",
  "<leader>sr",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "[S]earch and [R]eplace (with regex over whole file) currenft word" }
)
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make current file e[x]ecutable" })

-- Tabs
vim.keymap.set("n", "<leader><S-Tab>", ":set invlist<CR>", { desc = "Show tabs" })
