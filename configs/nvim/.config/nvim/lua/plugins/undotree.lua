return {
  "mbbill/undotree",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    vim.keymap.set("n", "<leader>U", vim.cmd.UndotreeToggle)
  end,
}
