-- require('gen').model = 'codellama' -- default 'mistral:instruct'

require("gen").setup({
  model = "deepseek-coder", -- The default model to use.
  host = "localhost", -- The host running the Ollama service.
  port = "11434", -- The port on which the Ollama service is listening.
  display_mode = "split", -- The display mode. Can be "float" or "split".
  show_prompt = false, -- Shows the Prompt submitted to Ollama.
  show_model = true, -- Displays which model you are using at the beginning of your chat session.
  no_auto_close = false, -- Never closes the window automatically.
  init = function(options)
    pcall(io.popen, "ollama serve > /dev/null 2>&1 &")
  end,
  -- Function to initialize Ollama
  command = function(options)
    return "curl --silent --no-buffer -X POST http://"
      .. options.host
      .. ":"
      .. options.port
      .. "/api/generate -d $body"
  end,
  -- The command for the Ollama service. You can use placeholders $prompt, $model and $body (shellescaped).
  -- This can also be a command string.
  -- The executed command must return a JSON object with { response, context }
  -- (context property is optional).
  -- list_models = '<omitted lua function>', -- Retrieves a list of model names
  debug = false, -- Prints errors and the command which is run.
})

vim.keymap.set({ "n", "v" }, "<leader>o", ":Gen<CR>")

require("gen").prompts["Devops"] = {
  prompt = "You are a senior devops engineer, acting as an assistant. You offer help with cloud technologies like: Terraform, AWS, kubernetes, python. You answer with code examples when possible. $input:\n$text",
  replace = true,
}

-- TODO: Generate useful hotkeys
