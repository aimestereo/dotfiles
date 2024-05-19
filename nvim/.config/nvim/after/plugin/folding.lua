vim.g.disable_autofolding = true

local enable_folding = function()
  if require("nvim-treesitter.parsers").has_parser() then
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
  else
    -- vim.opt.foldmethod = "indent"
    vim.opt.foldmethod = "syntax"
  end
end

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  callback = function()
    if vim.g.disable_autofolding then
      -- start with all folds open
      vim.cmd("normal! zR")
    else
      enable_folding()
    end
  end,
})

-- Configure auto folding
vim.api.nvim_create_user_command("FoldingEnable", function()
  vim.g.disable_autofolding = false
  enable_folding()
  print("Autofolding re-enabled")
end, {
  desc = "Re-enable autofolding",
})

vim.api.nvim_create_user_command("FoldingDisable", function()
  vim.g.disable_autofolding = true
  vim.cmd("normal zR")
  print("Autofolding disabled")
end, {
  desc = "Disable autofolding",
})
