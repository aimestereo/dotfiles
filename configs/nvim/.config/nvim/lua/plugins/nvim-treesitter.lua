return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    --"windwp/nvim-ts-autotag",
  },
  ---@class TSConfig
  opts = {
    highlight = {
      enable = true,
    },
    -- enable indentation
    indent = { enable = true },
    -- enable autotagging (w/ nvim-ts-autotag plugin)
    autotag = {
      enable = true,
    },

    -- ensure these language parsers are installed
    -- requires manual handling
    ensure_installed = {
      -- terminal
      "sh",
      "bash",
      "zsh",
      "tmux",
      "cmake",
      "jq",
      -- configs
      "ini",
      "xml",
      "toml",
      "yaml",
      "hyprlang",
      -- git
      "diff",
      "git_config",
      "git_rebase",
      "gitattributes",
      "gitcommit",
      "gitignore",
      -- devops
      "dockerfile",
      "terraform",
      "hcl",
      -- webdev
      "javascript",
      "tsx",
      "typescript",
      "graphql",
      "html",
      "htmldjango",
      "json",
      "svelte",
      "css",
      "prisma",
      "query",
      -- vim
      "vimdoc",
      "vim",
      -- others
      "markdown",
      "markdown_inline",
      -- languages
      "commonlisp",
      "nix",
      "go",
      "python",
      "rust",
      "sql",
      "zig",
      "lua",
      "regex",
    },

    -- no longer supported by treesitter
    -- incremental_selection = {
    --   enable = true,
    --   keymaps = {
    --     init_selection = "<C-space>",
    --     node_incremental = "<C-space>",
    --     scope_incremental = false,
    --     node_decremental = "<bs>",
    --   },
    -- },

    -- enable nvim-ts-context-commentstring plugin for commenting tsx and jsx
    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },
  },
  config = function(_, opts)
    -- install parsers from custom opts.ensure_installed
    if opts.ensure_installed and #opts.ensure_installed > 0 then
      require("nvim-treesitter").install(opts.ensure_installed)
      -- register and start parsers for filetypes
      for _, parser in ipairs(opts.ensure_installed) do
        local filetypes = parser -- In this case, parser is the filetype/language name
        vim.treesitter.language.register(parser, filetypes)

        vim.api.nvim_create_autocmd({ "FileType" }, {
          pattern = filetypes,
          callback = function(event)
            vim.treesitter.start(event.buf, parser)
          end,
        })
      end
    end

    -- Auto-install and start parsers for any buffer
    vim.api.nvim_create_autocmd({ "BufRead" }, {
      callback = function(event)
        local bufnr = event.buf
        local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })

        -- Skip if no filetype
        if filetype == "" then
          vim.notify("Buffer has no Filetype ", vim.log.levels.WARN, { title = "core/treesitter" })
          return
        end

        -- Check if this filetype is already handled by explicit opts.ensure_installed config
        for _, filetypes in pairs(opts.ensure_installed) do
          local ft_table = type(filetypes) == "table" and filetypes or { filetypes }
          if vim.tbl_contains(ft_table, filetype) then
            -- vim.notify(
            --   "Filetype " .. vim.inspect(filetype) .. " already handled by explicit config",
            --   vim.log.levels.WARN,
            --   { title = "core/treesitter" }
            -- )
            return -- Already handled above
          end
        end

        -- Get parser name based on filetype
        local parser_name = vim.treesitter.language.get_lang(filetype) -- might return filetype (not helpful)
        if not parser_name then
          -- vim.notify(
          --   "No parser name found for filetype " .. vim.inspect(filetype),
          --   vim.log.levels.WARN,
          --   { title = "core/treesitter" }
          -- )
          return
        end

        -- Try to get existing parser (helpful check if filetype was returned above)
        local parser_configs = require("nvim-treesitter.parsers")
        if not parser_configs[parser_name] then
          -- vim.notify(
          --   "No parser config found for parser name " .. vim.inspect(parser_name),
          --   vim.log.levels.WARN,
          --   { title = "core/treesitter" }
          -- )
          return -- Parser not available, skip silently
        end

        local parser_installed = pcall(vim.treesitter.get_parser, bufnr, parser_name)
        if not parser_installed then
          -- If not installed, install parser synchronously
          -- vim.notify(
          --   "Parser " .. parser_name .. " not installed. Installing...",
          --   vim.log.levels.WARN,
          --   { title = "core/treesitter" }
          -- )
          require("nvim-treesitter").install({ parser_name }):wait(30000)
        end

        -- let's check again
        parser_installed = pcall(vim.treesitter.get_parser, bufnr, parser_name)
        if not parser_installed then
          -- vim.notify(
          --   "Failed to get parser for " .. parser_name .. " after installation",
          --   vim.log.levels.WARN,
          --   { title = "core/treesitter" }
          -- )
          return
        end

        -- Start treesitter for this buffer
        vim.notify(
          "Starting treesitter for filetype " .. filetype .. " with parser " .. parser_name,
          vim.log.levels.INFO,
          { title = "core/treesitter" }
        )
        vim.treesitter.start(bufnr, parser_name)
      end,
    })
  end,
}
