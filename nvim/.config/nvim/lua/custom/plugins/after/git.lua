function Map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

local neogit = require("neogit")

Map("n", "<leader>gs", function()
  neogit.open({ kind = "replace" })
end, { desc = "Neogit status" })

Map("n", "<leader>gc", ":Neogit commit<CR>")
Map("n", "<leader>gp", ":Neogit pull<CR>")
Map("n", "<leader>gP", ":Neogit push<CR>")
Map("n", "<leader>gb", ":Telescope git_branches<CR>")
Map("n", "<leader>gB", ":Git blame<CR>")
