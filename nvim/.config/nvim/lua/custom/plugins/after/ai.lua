-- Copilot
vim.g.copilot_assume_mapped = true
vim.keymap.del("i", "<Tab>")
vim.g.copilot_no_tab_map = true
vim.keymap.set("i", "<C-y>", 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false,
})

-- Gen
require("gen").setup({
  model = "mistral", -- The default model to use.
  host = "127.0.0.1", -- The host running the Ollama service.
  port = "11434", -- The port on which the Ollama service is listening.
  display_mode = "split", -- The display mode. Can be "float" or "split".
  show_prompt = true, -- Shows the Prompt submitted to Ollama.
  show_model = true, -- Displays which model you are using at the beginning of your chat session.
  no_auto_close = false, -- Never closes the window automatically.
  debug = false, -- Prints errors and the command which is run.
})

vim.keymap.set({ "n", "v" }, "<leader>om", require("gen").select_model)
vim.keymap.set({ "n", "v" }, "<leader>oo", ":Gen<CR>")

require("gen").prompts["Devops"] = {
  prompt = "You are a senior devops engineer, acting as an assistant. You offer help with cloud technologies like: Terraform, AWS, kubernetes, python. You answer with code examples when possible. $input:\n$text",
  replace = true,
}

-- TODO: Generate useful hotkeys
