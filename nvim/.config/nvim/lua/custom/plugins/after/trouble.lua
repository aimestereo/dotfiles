function Map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

Map("n", "<leader>xx", function()
  require("trouble").toggle()
end, { desc = "Toggle Trouble" })

Map("n", "<leader>xw", function()
  require("trouble").toggle("workspace_diagnostics")
end, { desc = "workspace diagnostics" })

Map("n", "<leader>xd", function()
  require("trouble").toggle("document_diagnostics")
end, { desc = "document diagnostics" })

Map("n", "<leader>xq", function()
  require("trouble").toggle("quickfix")
end, { desc = "quickfix list" })

Map("n", "<leader>xl", function()
  require("trouble").toggle("loclist")
end, { desc = "loclist" })

Map("n", "<leader>xR", function()
  require("trouble").toggle("lsp_references")
end, { desc = "LSP references" })
