-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("utils")

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Disable LazyVim's automatic checking for plugin order (omarchy theme loads lazyvim plugin)
vim.g.lazyvim_check_order = false

-- Check OS, for macos import plugins.macos, for linux import plugins.linux
local os_name = vim.loop.os_uname().sysname
local os_plugins = {}
if os_name == "Darwin" then
  os_plugins = { import = "plugins.macos" }
elseif os_name == "Linux" then
  os_plugins = { import = "plugins.linux" }
end

require("lazy").setup({
  spec = {
    { import = "plugins" },
    os_plugins,
  },
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
})

vim.api.nvim_command("autocmd BufNewFile .mise.toml 0r ~/.config/nvim/templates/mise.toml")
vim.api.nvim_command("autocmd BufNewFile main.go 0r ~/.config/nvim/templates/main.go")
