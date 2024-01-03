-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
return {
  -- clangd = {},
  gopls = {},
  pyright = {},
  rust_analyzer = {},
  tsserver = {},
  html = {},
  cssls = {},
  tailwindcss = {},
  svelte = {},
  graphql = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
  emmet_ls = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
  prismals = {},

  lua_ls = {
    Lua = {
      -- make the language server recognize "vim" global
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        --checkThirdParty = false,

        -- make language server aware of runtime files
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.stdpath("config") .. "/lua"] = true,
        },
      },
      telemetry = { enable = false },
    },
  },
}
