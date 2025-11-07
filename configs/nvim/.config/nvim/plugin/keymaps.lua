--
-- Buffers
--
-- close current buffer without closing split (by moving first to previous buffer)
Map({ "n" }, "<A-x>", ":bp|bd #<cr>", { desc = "[C]lose current buffer" })
Map({ "n" }, "<A-s>", ":wa<cr>", { desc = "[S]ave all changed files" })
Map({ "i" }, "<A-s>", "<esc>:wa<cr>", { desc = "[S]ave all changed files" })

--
-- Splits
--
-- see nvim-tmux-navigation.lua for navigation
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
Map("v", "<A-p>", '"_d"+P', { desc = "[P]aste clipboard without overwriting register" })

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
Map({ "n", "v" }, "<Space>", "<Nop>")
Map({ "n", "v" }, "<A-/>", "<cmd>nohlsearch<CR>")

-- Remap for dealing with word wrap
Map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
Map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- Concatenate with next line and keep cursor at the same position
Map("n", "J", "mzJ`z", { desc = "Concatenate with next line and keep cursor at the same position" })

-- Scroll stops working with long wrapped lines
-- Map("n", "<C-d>", "<C-d>zz", { desc = "Scroll [d]own half-page and center cursor" })
-- Map("n", "<C-u>", "<C-u>zz", { desc = "Scroll [u]p half-page and center cursor" })

Map("n", "n", "nzzzv", { desc = "Go to a [n]ext match, keep cursor at the center of the screen" })
Map("n", "N", "Nzzzv", { desc = "Go to a previous match, keep cursor at the center of the screen" })

-- Center the screen after searching for the next/prev occurrence of the word under the cursor
Map("n", "*", "*zzzv", { desc = "Search the word under the cursor and center the screen" })
Map("n", "#", "#zzzv", { desc = "Search back the word under the cursor and center the screen" })

-- Center the screen after searching for the next/prev partial match under the cursor
Map("n", "g*", "g*zzzv", { desc = "Search the partial match under the cursor and center the screen" })
Map("n", "g#", "g#zzzv", { desc = "Search back the partial match under the cursor and center the screen" })

-- Center the screen after jumping to older/newer cursor positions
Map("n", "<C-o>", "<C-o>zz", { desc = "Go to the [o]lder cursor position and center the screen" })
Map("n", "<C-i>", "<C-i>zz", { desc = "Go to the [i]nner cursor position and center the screen" })

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

--
-- Avante
--
-- press `D` to remove all todos
vim.api.nvim_create_autocmd("FileType", {
  pattern = "AvanteTodos",
  callback = function(ctx)
    vim.keymap.set("n", "D", function()
      require("avante").get():update_todos({})
    end, { buffer = ctx.buf })
  end,
})

-- press `D` to remove selected code
vim.api.nvim_create_autocmd("FileType", {
  pattern = "AvanteSelectedCode",
  callback = function(ctx)
    vim.keymap.set("n", "D", function()
      local sidebar = require("avante").get()
      sidebar.code.selection = nil
      sidebar.containers.selected_code:unmount()
      sidebar.containers.selected_code = nil
    end, { buffer = ctx.buf })
  end,
})
