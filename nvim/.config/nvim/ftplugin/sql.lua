local keymap = vim.keymap

-- visually select the area under the cursor and run the query
keymap.set("n", "<A-r>", ":normal vip<CR><PLUG>(DBUI_ExecuteQuery)", { buffer = true })
-- execute whole buffer or selected area
keymap.set("v", "<A-r>", "<PLUG>(DBUI_ExecuteQuery)", { buffer = true })
keymap.set("n", "<A-R>", "<PLUG>(DBUI_ExecuteQuery)", { buffer = true })

keymap.set("n", "<leader>w", "<PLUG>(DBUI_SaveQuery)", { buffer = true })
