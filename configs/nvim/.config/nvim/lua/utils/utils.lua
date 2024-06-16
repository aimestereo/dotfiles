--- Return the current buffer content
--- @param buf number
function GET_CURRENT_BUFFER_CONTENT(buf)
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  return lines
end

function GET_SELECTED_LINES()
  local vstart = vim.fn.getpos("v")[2]
  local vend = vim.fn.getpos(".")[2]
  local lines = vim.fn.getline(vstart, vend)
  return lines
end

--- Execute a command and return the output
--- @param args string[]
function EXEC(args)
  local cmd = table.concat(args, " ")
  cmd = vim.api.nvim_replace_termcodes(cmd, true, false, true)

  local output = vim.api.nvim_exec2(cmd, { output = true })["output"]
  return vim.split(output, "\n", { plain = true })
end

--- Output the source and its result to a new buffer
--- @param lang string
--- @param source_code string[]
--- @param output string[]
function OUTPUT_TO_BUFFER(lang, source_code, output)
  vim.cmd("enew")

  local result = {}
  if source_code then
    table.insert(result, "```" .. lang)
    for _, line in ipairs(source_code) do
      table.insert(result, line)
    end
    table.insert(result, "```")
    vim.cmd("set ft=markdown")
  end

  for idx, line in ipairs(output) do
    if idx ~= 1 then
      table.insert(result, line)
    end
  end

  vim.api.nvim_buf_set_lines(0, 0, -1, false, result)
  vim.opt_local.modified = false
end

--- Run the cmd via Neovim built-in terminal
--- @param args string[]
--- @param interactive boolean
function RUN_IN_TERMINAL(args, interactive)
  local cmd = table.concat(args, " ")
  if interactive then
    cmd = "i" .. cmd .. "<CR>"
  end
  cmd = vim.api.nvim_replace_termcodes(cmd, true, false, true)

  if interactive then
    vim.cmd(":term")
    -- Press keys to run python command on current file
    vim.api.nvim_feedkeys(cmd, "t", false)
  else
    vim.cmd(":term " .. cmd) -- Launch terminal (horizontal split)
  end
end
