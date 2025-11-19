-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.

return {
  -- clangd = {},
  gopls = {},
  -- yamlls = {},
  helm_ls = {
    helm_ls = {
      ["helm-ls"] = {
        -- yamlls = {
        --   path = "yaml-language-server",
        -- },
      },
    },
  },

  ruff = {},

  pyright = {
    pyright = {
      -- Using Ruff's import organizer
      disableOrganizeImports = true,
    },
    python = {
      -- analysis = {
      --   -- Ignore all files for analysis to exclusively use Ruff for linting
      --   ignore = { "*" },
      -- },
    },
  },

  ts_ls = {
    javascript = {
      inlayHints = {
        includeInlayEnumMemberValueHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayVariableTypeHints = true,
      },
    },

    typescript = {
      inlayHints = {
        includeInlayEnumMemberValueHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayVariableTypeHints = true,
      },
    },
  },
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
        globals = {},
        disable = { "missing-fields" },
      },
      hint = {
        enable = true,
      },
      workspace = {
        --checkThirdParty = false,

        -- make language server aware of runtime files
        library = {
          vim.fn.expand("$VIMRUNTIME/lua"),
          vim.fn.stdpath("config") .. "/lua",
          "/Applications/Hammerspoon.app/Contents/Resources/extensions/hs",
          string.format("%s/.hammerspoon/Spoons/EmmyLua.spoon/annotations", os.getenv("HOME")),
        },
      },
      telemetry = { enable = false },
    },
  },

  -- Spell checking language server configuration
  harper_ls = {
    ["harper-ls"] = {
      userDictPath = "",
      workspaceDictPath = "",
      fileDictPath = "",
      linters = {
        SpellCheck = false,
        SpelledNumbers = false,
        AnA = true,
        SentenceCapitalization = false,
        UnclosedQuotes = true,
        WrongQuotes = false,
        LongSentences = true,
        RepeatedWords = true,
        Spaces = true,
        Matcher = true,
        CorrectNumberSuffix = true,
      },
      codeActions = {
        ForceStable = false,
      },
      markdown = {
        IgnoreLinkTitle = false,
      },
      diagnosticSeverity = "hint",
      isolateEnglish = false,
      dialect = "American",
      maxFileLength = 120000,
      ignoredLintsPath = "",
      excludePatterns = {},
    },
  },
}
