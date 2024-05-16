local temp_file = vim.api.nvim_call_function("tempname", {})

local function run_curr_python_file_in_terminal()
  print("Running current python file in terminal")
  local file_name = vim.api.nvim_buf_get_name(0)
  RUN_IN_TERMINAL({ "python", file_name }, true)
end

local function run_lines_in_terminal()
  print("Running selected lines in terminal")
  local lines = GET_SELECTED_LINES()
  vim.api.nvim_call_function("writefile", { lines, temp_file })
  RUN_IN_TERMINAL({ "python", temp_file }, true)
end

local function run_curr_python_file()
  print("Running current python file")
  local lines = GET_CURRENT_BUFFER_CONTENT(0)
  local file_name = vim.api.nvim_buf_get_name(0)
  RUN_IN_TERMINAL({ "python", file_name }, false)

  -- local output = EXEC({ "!python", '"' .. file_name .. '"' })
  -- OUTPUT_TO_BUFFER("python", lines, output)
end

local function run_lines()
  print("Running selected lines")
  local lines = GET_SELECTED_LINES()
  vim.api.nvim_call_function("writefile", { lines, temp_file })
  RUN_IN_TERMINAL({ "python", temp_file }, false)

  -- local output = EXEC({ "!python", '"' .. temp_file .. '"' })
  -- OUTPUT_TO_BUFFER("python", lines, output)
end

-- Key mappings

vim.keymap.set({ "n" }, "<A-R>", "", {
  desc = "Run .py file via Neovim built-in terminal",
  callback = run_curr_python_file,
})
vim.keymap.set({ "n" }, "<leader><A-R>", "", {
  desc = "Run .py file via Neovim built-in terminal",
  callback = run_curr_python_file_in_terminal,
})

vim.keymap.set({ "n", "v" }, "<A-r>", "", {
  desc = "Run lines via Neovim built-in terminal",
  callback = run_lines,
})
vim.keymap.set({ "n", "v" }, "<leader><A-r>", "", {
  desc = "Run lines via Neovim built-in terminal",
  callback = run_lines_in_terminal,
})
