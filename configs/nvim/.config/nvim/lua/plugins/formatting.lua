return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = { "n", "v" },
      desc = "Format buffer",
    },
  },
  config = function()
    local slow_format_filetypes = {}

    require("conform").setup({
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
        yaml = { "prettier" },
        markdown = { "prettier" },
        graphql = { "prettier" },
        lua = { "stylua" },
        python = { "ruff_fix", "ruff_format" },
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
      formatters = {
        ruff_fix = {
          prepend_args = { "check", "--select", "I" },
        },
        pg_format = {
          args = {
            -- "--wrap-limit=70",
            "--wrap-after=1",
            -- "--keyword-case=2",
          },
        },
      },

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
    })

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
