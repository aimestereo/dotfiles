local function map(mode, l, r, opts)
  opts = opts or {}
  vim.keymap.set(mode, l, r, opts)
end

--
-- Buffers
--
-- close current buffer without closing split (by moving first to previous buffer)
map({ "n" }, "<A-x>", ":bp|bd #<cr>", { desc = "[C]lose current buffer" })
map({ "n" }, "<A-s>", ":wa<cr>", { desc = "[S]ave all changed files" })
map({ "i" }, "<A-s>", "<esc>:wa<cr>", { desc = "[S]ave all changed files" })
map({ "n" }, "<A-g>", ":0G<cr>", { desc = "Open [G]it fugitive in current pane." })

--
-- Splits
--
--map({ "n" }, "<A-w>", "<C-w>", { desc = "[W]indow (Splits) manager" })
--map({ "n" }, "<A-w>", ":echo 'hi'", { desc = "[W]indow (Splits) manager" })
map("n", "<C-h>", "<C-w>h", { desc = "[W]indow (Splits) manager" })
map("n", "<C-j>", "<C-w>j", { desc = "[W]indow (Splits) manager" })
map("n", "<C-k>", "<C-w>k", { desc = "[W]indow (Splits) manager" })
map("n", "<C-l>", "<C-w>l", { desc = "[W]indow (Splits) manager" })

map("n", "<A-Up>", ":resize +2<CR>", { desc = "Resize Window (Split)" })
map("n", "<A-Down>", ":resize -2<CR>", { desc = "Resize Window (Split)" })
map("n", "<A-Left>", ":vertical resize -2<CR>", { desc = "Resize Window (Split)" })
map("n", "<A-Right>", ":vertical resize +2<CR>", { desc = "Resize Window (Split)" })

--
-- Helix or inspired by it
--
--map('n', 'd', 'x', { desc = "Delete symbol under cursor" })
map("n", "U", "<C-r>", { desc = "Redo (Reverse [U]ndo)" })
map("v", "<A-;>", "o", { desc = "Flips selection." })

map("n", "<A-c>", '"_cl', { desc = "[C]hange symbol/selection avoiding yank" })
map("n", "<A-d>", '"_dl', { desc = "[D]elete symbol/selection avoiding yank" })
map("v", "<A-c>", '"_c', { desc = "[C]hange symbol/selection avoiding yank" })
map("v", "<A-d>", '"_d', { desc = "[D]elete symbol/selection avoiding yank" })

map("x", "<A-p>", [["_dP]], { desc = "[P]aste without overwriting register" })
map("v", "<leader>p", [["_d"+P]], { desc = "[P]aste clipboard without overwriting register" })

map({ "n", "v" }, "<leader>y", [["+y]], { desc = "[Y]ank to system clipboard" })
map("n", "<leader>Y", [["+Y]], { desc = "[Y]ank current line to system clipboard" })

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
map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })

--
-- from ThePrimeagen: https://www.youtube.com/watch?v=w7i4amO_zaE&t=38s&ab_channel=ThePrimeagen
--
map("n", "<C-e>", vim.cmd.Ex, { desc = "Open file [E]xplorer / vim folder view containing current file" })

-- Move selected line / block of text in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down in visual mode" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up in visual mode" })

-- Concatenate with next line and keep cursor at the same position
map("n", "J", "mzJ`z", { desc = "Concatenate with next line and keep cursor at the same position" })

map("n", "<C-d>", "<C-d>zz", { desc = "Scroll [d]own half-page and center cursor" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll [u]p half-page and center cursor" })

map("n", "n", "nzzzv", { desc = "Go to a [n]ext match, keep cursor at the center of the screen" })
map("n", "N", "Nzzzv", { desc = "Go to a previous match, keep cursor at the center of the screen" })

map("i", "<C-c>", "<Esc>", { desc = "Esc" })
map("n", "Q", "<nop>", { desc = "Silence Q" })

map(
  "n",
  "<leader>sr",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "[S]earch and [R]eplace (with regex over whole file) currenft word" }
)
map("n", "<leader>x", "<cmd>!chmod +x %<CR>", { desc = "Make current file e[x]ecutable" })

-- Tabs
map("n", "<leader><S-Tab>", ":set invlist<CR>", { desc = "Show tabs" })
