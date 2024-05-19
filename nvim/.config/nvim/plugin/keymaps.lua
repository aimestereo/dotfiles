--
-- Buffers
--
-- close current buffer without closing split (by moving first to previous buffer)
Map({ "n" }, "<A-x>", ":bp|bd #<cr>", { desc = "[C]lose current buffer" })
Map({ "n" }, "<A-s>", ":wa<cr>", { desc = "[S]ave all changed files" })
Map({ "i" }, "<A-s>", "<esc>:wa<cr>", { desc = "[S]ave all changed files" })
Map({ "n" }, "<A-g>", ":0G<cr>", { desc = "Open [G]it fugitive in current pane." })

--
-- Splits
--
--map({ "n" }, "<A-w>", "<C-w>", { desc = "[W]indow (Splits) manager" })
--map({ "n" }, "<A-w>", ":echo 'hi'", { desc = "[W]indow (Splits) manager" })
Map("n", "<C-h>", "<C-w>h", { desc = "[W]indow (Splits) manager" })
Map("n", "<C-j>", "<C-w>j", { desc = "[W]indow (Splits) manager" })
Map("n", "<C-k>", "<C-w>k", { desc = "[W]indow (Splits) manager" })
Map("n", "<C-l>", "<C-w>l", { desc = "[W]indow (Splits) manager" })

Map("n", "<A-Up>", ":resize +2<CR>", { desc = "Resize Window (Split)" })
Map("n", "<A-Down>", ":resize -2<CR>", { desc = "Resize Window (Split)" })
Map("n", "<A-Left>", ":vertical resize -2<CR>", { desc = "Resize Window (Split)" })
Map("n", "<A-Right>", ":vertical resize +2<CR>", { desc = "Resize Window (Split)" })

--
-- Helix or inspired by it
--
Map("n", "U", "<C-r>", { desc = "Redo (Reverse [U]ndo)" })

Map("n", "<A-c>", '"_cl', { desc = "[C]hange symbol/selection avoiding yank" })
Map("n", "<A-d>", '"_dl', { desc = "[D]elete symbol/selection avoiding yank" })
Map("v", "<A-c>", '"_c', { desc = "[C]hange symbol/selection avoiding yank" })
Map("v", "<A-d>", '"_d', { desc = "[D]elete symbol/selection avoiding yank" })

Map("x", "<A-p>", '"_dP', { desc = "[P]aste without overwriting register" })
Map("v", "<leader>p", '"_d"+P', { desc = "[P]aste clipboard without overwriting register" })

Map({ "n", "v" }, "<leader>y", '"+y', { desc = "[Y]ank to system clipboard" })
Map("n", "<leader>Y", '"+Y', { desc = "[Y]ank current line to system clipboard" })

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
Map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
Map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
Map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })

--
-- from ThePrimeagen: https://www.youtube.com/watch?v=w7i4amO_zaE&t=38s&ab_channel=ThePrimeagen
--
Map("n", "<C-e>", vim.cmd.Ex, { desc = "Open file [E]xplorer / vim folder view containing current file" })

-- Concatenate with next line and keep cursor at the same position
Map("n", "J", "mzJ`z", { desc = "Concatenate with next line and keep cursor at the same position" })

Map("n", "<C-d>", "<C-d>zz", { desc = "Scroll [d]own half-page and center cursor" })
Map("n", "<C-u>", "<C-u>zz", { desc = "Scroll [u]p half-page and center cursor" })

Map("n", "n", "nzzzv", { desc = "Go to a [n]ext match, keep cursor at the center of the screen" })
Map("n", "N", "Nzzzv", { desc = "Go to a previous match, keep cursor at the center of the screen" })

Map("i", "<C-c>", "<Esc>", { desc = "Esc" })
Map("n", "Q", "<nop>", { desc = "Silence Q" })

Map(
  "n",
  "<leader>sr",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "[S]earch and [R]eplace (with regex over whole file) currenft word" }
)

Map("n", "<leader>X", "<cmd>!chmod +x %<CR>", { desc = "Make current file e[x]ecutable" })

-- Tabs
Map("n", "<leader><S-Tab>", ":set invlist<CR>", { desc = "Show tabs" })

-- Quickfix list: quick navigation
vim.keymap.set(
  "n",
  "<leader>j",
  "<cmd>cnext<CR>zz",
  { desc = "Moves the cursor to the next item in the quickfix list" }
)
vim.keymap.set(
  "n",
  "<leader>k",
  "<cmd>cprev<CR>zz",
  { desc = "Moves the cursor to the previous item in the quickfix list" }
)

-- Move selected line / block of text in visual mode
Map("v", "<M-j>", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down in visual mode" })
Map("v", "<M-k>", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up in visual mode" })

Map("n", "<M-j>", function()
  if vim.opt.diff:get() then
    vim.cmd([[normal! ]c]])
  else
    vim.cmd([[m .+1<CR>==]])
  end
end, { desc = "Move current line down" })

Map("n", "<M-k>", function()
  if vim.opt.diff:get() then
    vim.cmd([[normal! [c]])
  else
    vim.cmd([[m .-2<CR>==]])
  end
end, { desc = "Move current line up" })
