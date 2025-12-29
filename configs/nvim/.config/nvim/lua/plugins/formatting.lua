return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = { "n", "v" },
      desc = "Format buffer",
    },
  },
  config = function()
    local slow_format_filetypes = {}
    local conform = require("conform")

    --
    -- Global conform setup
    --

    local global_opts = {
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          -- Disable with a global or buffer-local variable
          return
        end

        if slow_format_filetypes[vim.bo[bufnr].filetype] then
          return
        end
        local function on_format(err)
          if err and err:match("timeout$") then
            slow_format_filetypes[vim.bo[bufnr].filetype] = true
          end
        end

        return { timeout_ms = 1000, lsp_fallback = true }, on_format
      end,

      format_after_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          -- Disable with a global or buffer-local variable
          return
        end

        if not slow_format_filetypes[vim.bo[bufnr].filetype] then
          return
        end
        return { lsp_fallback = true }
      end,
    }
    -- Apply global options
    conform.setup(global_opts)

    --
    -- Per-project configuration loading
    -- It looks for a `.conform.json` file in the git repository root
    -- Project-specific config overrides the defaults defined below
    --

    -- Constant path to the config file (relative to git root)
    local config_filename = ".conform.json"

    -- Default formatters if no config file present
    local defaults = {
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        terraform = { "tofu_fmt" },
        svelte = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "yamlfmt" },
        markdown = { "prettier" },
        graphql = { "prettier" },
        lua = { "stylua" },
        -- python = { "ruff_fix", "ruff_format" },
        python = { "ruff_organize_imports", "ruff_format" },
        nix = { "nixfmt" },
        -- sql = { "sql_formatter" },
        sql = { "pg_format" },
        sh = {
          -- "shellcheck", -- A static analysis tool for shell scripts.
          "shellharden", -- The corrective bash syntax highlighter.
          "shfmt", -- A shell parser, formatter, and interpreter with bash support.
        },
      },
      -- Customize formatters
      args = {
        ruff_fix = { "check", "--select", "I" },
        pg_format = {
          -- "--wrap-limit=70",
          "--wrap-after=1",
          -- "--keyword-case=2",
        },
      },
    }

    --- Load configuration from `.conform.json` in the git repository root
    --- Example `.conform.json`:
    -- {
    --   "formatters_by_ft": {
    --     "python": ["isort", "yapf"],
    --     "json": ["prettier"],
    --     "yaml": ["prettier"]
    --   },
    --   "args": {
    --     "yapf": ["--style", "{based_on_style: pep8, indent_width: 4}"],
    --     "isort": ["--profile", "open_stack", "--line-length", "79"]
    --   }
    -- }

    local load_config = function(bufnr)
      local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":h")
      local git_root = vim.fn.systemlist("git -C " .. vim.fn.fnameescape(path) .. " rev-parse --show-toplevel")[1]

      if vim.v.shell_error ~= 0 or not git_root then
        -- vim.notify("No git root found, using defaults", vim.log.levels.DEBUG)
        return nil
      end

      local cfg_path = git_root .. "/" .. config_filename
      if vim.fn.filereadable(cfg_path) == 0 then
        -- vim.notify("No " .. config_filename .. " found, using defaults", vim.log.levels.DEBUG)
        return nil
      end

      local ok_read, content = pcall(vim.fn.readfile, cfg_path)
      if not ok_read or not content then
        vim.notify("Failed to read " .. cfg_path, vim.log.levels.ERROR)
        return nil
      end

      local ok_parse, parsed = pcall(vim.fn.json_decode, table.concat(content, "\n"))
      if not ok_parse then
        vim.notify("Invalid JSON in " .. cfg_path, vim.log.levels.ERROR)
        return nil
      end

      return {
        formatters_by_ft = vim.tbl_extend("force", defaults.formatters_by_ft, parsed.formatters_by_ft or {}),
        args = vim.tbl_extend("force", defaults.args, parsed.args or {}),
      }
    end

    local orig_format = conform.format

    conform.format = function(opts)
      local bufnr = opts.buf or vim.api.nvim_get_current_buf()
      local cfg = load_config(bufnr) or defaults
      -- vim.notify("Using conform config: " .. vim.inspect(cfg), vim.log.levels.DEBUG)

      conform.formatters_by_ft = cfg.formatters_by_ft

      for name, arg_list in pairs(cfg.args) do
        conform.formatters[name] = conform.formatters[name] or {}
        conform.formatters[name].prepend_args = function()
          return arg_list
        end
      end

      orig_format(opts)
    end

    --
    -- Commands
    --

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
  end,
}
