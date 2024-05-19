vim.keymap.set("n", "<A-r>", ":.w !bash<CR>", { buffer = 0, desc = "Execute the current bash line" })
vim.keymap.set("n", "<A-R>", ":w !bash<CR>", { buffer = 0, desc = "Execute bash file" })
