return {
  {
    "shortcuts/no-neck-pain.nvim",
    config = function()
      require("no-neck-pain").setup({
        mappings = {
          -- When `true`, creates all the mappings that are not set to `false`.
          --- @type boolean
          enabled = true,
        },
        autocmds = {
          -- When `true`, enables the plugin when you start Neovim.
          -- If the main window is  a side tree (e.g. NvimTree) or a dashboard, the command is delayed until it finds a valid window.
          -- The command is cleaned once it has successfuly ran once.
          --- @type boolean
          enableOnVimEnter = true,
          -- When `true`, enables the plugin when you enter a new Tab.
          -- note: it does not trigger if you come back to an existing tab, to prevent unwanted interfer with user's decisions.
          --- @type boolean
          enableOnTabEnter = true,
        },
        buffers = {
          scratchPad = {
            -- set to `false` to
            -- disable auto-saving
            enabled = true,
            -- set to `nil` to default
            -- to current working directory
            location = "~/Documents/",
          },
          bo = {
            filetype = "md",
          },
        },
      })
    end,
  },
}
