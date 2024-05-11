-- Fold code using treesitter if available
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  callback = function()
    if require("nvim-treesitter.parsers").has_parser() then
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    else
      -- vim.opt.foldmethod = "indent"
      vim.opt.foldmethod = "syntax"
    end

    if vim.g.disable_autofolding then
      -- start with all folds open
      vim.cmd("normal! zR")
    end
  end,
})

-- Configure auto folding
vim.api.nvim_create_user_command("FoldingEnable", function()
  vim.g.disable_autofolding = false
  print("Autofolding re-enabled")
end, {
  desc = "Re-enable autofolding",
})

vim.api.nvim_create_user_command("FoldingDisable", function()
  vim.g.disable_autofolding = true
  print("Autofolding disabled")
end, {
  desc = "Disable autofolding",
})
