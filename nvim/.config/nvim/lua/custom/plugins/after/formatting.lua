vim.api.nvim_create_user_command("FormatDisable", function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
    print("Disable autoformat-on-save for this buffer")
  else
    vim.g.disable_autoformat = true
    print("Disable autoformat-on-save")
  end
end, {
  desc = "Disable autoformat-on-save",
  bang = true,
})
vim.api.nvim_create_user_command("FormatEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
  print("Re-enable autoformat-on-save")
end, {
  desc = "Re-enable autoformat-on-save",
})
