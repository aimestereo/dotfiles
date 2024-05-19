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
  local file_name = vim.api.nvim_buf_get_name(0)
  RUN_IN_TERMINAL({ "python", file_name }, false)
end

local function run_lines()
  print("Running selected lines")
  local lines = GET_SELECTED_LINES()
  vim.api.nvim_call_function("writefile", { lines, temp_file })
  RUN_IN_TERMINAL({ "python", temp_file }, false)
end

-- Key mappings

vim.keymap.set({ "n" }, "<A-R>", "", {
  desc = "Run .py file non-interactive.",
  callback = run_curr_python_file,
  buffer = 0,
})
vim.keymap.set({ "n" }, "<leader><A-R>", "", {
  desc = "Run .py file interactive",
  callback = run_curr_python_file_in_terminal,
  buffer = 0,
})

vim.keymap.set({ "n", "v" }, "<A-r>", "", {
  desc = "Run py lines non-interactive",
  callback = run_lines,
  buffer = 0,
})
vim.keymap.set({ "n", "v" }, "<leader><A-r>", "", {
  desc = "Run py lines interactive",
  callback = run_lines_in_terminal,
  buffer = 0,
})
