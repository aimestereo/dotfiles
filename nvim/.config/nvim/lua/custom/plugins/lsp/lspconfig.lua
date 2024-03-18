return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },

    -- Useful status updates for LSP
    -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
    { "j-hui/fidget.nvim", tag = "legacy", opts = {} },

    -- Additional lua configuration, makes nvim stuff amazing!
    "folke/neodev.nvim",
  },
  config = function()
    -- IMPORTANT: make sure to setup neodev BEFORE lspconfig
    require("neodev").setup({
      library = { plugins = { "neotest" }, types = true },
    })

    -- import lspconfig plugin
    local lspconfig = require("lspconfig")
    -- import mason-lspconfig
    local mason_lspconfig = require("mason-lspconfig")

    -- import cmp-nvim-lsp plugin
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    local servers = require("custom.plugins.lsp.consts.servers")

    local keymap = vim.keymap -- for conciseness

    local opts = { noremap = true, silent = true }
    local on_attach = function(client, bufnr)
      opts.buffer = bufnr

      -- set keybinds
      opts.desc = "Show LSP references"
      keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

      opts.desc = "Go to declaration"
      keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

      opts.desc = "Show LSP definitions"
      keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

      opts.desc = "Show LSP implementations"
      keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

      opts.desc = "Show LSP type definitions"
      keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

      opts.desc = "See available code actions"
      keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

      opts.desc = "Smart rename"
      keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

      -- Documentation

      opts.desc = "Show documentation for what is under cursor"
      keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

      opts.desc = "Show signature documentation"
      keymap.set("n", "L", vim.lsp.buf.signature_help, opts)

      -- Symbols

      opts.desc = "[D]ocument [S]ymbols"
      keymap.set("n", "<leader>ds", require("telescope.builtin").lsp_document_symbols, opts)

      opts.desc = "[W]orkspace [S]ymbols"
      keymap.set("n", "<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, opts)

      -- Diagnostics

      opts.desc = "[T]oggle [D]iagnostics"
      keymap.set("n", "<leader>dtd", ":DiagnosticsToggle<CR>", opts)

      opts.desc = "[T]oggle [D]iagnostics [I]nline text"
      keymap.set("n", "<leader>dti", ":DiagnosticsToggleVirtualText<CR>", opts)

      opts.desc = "Show [D]ocument [D]iagnostics"
      keymap.set("n", "<leader>dd", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

      opts.desc = "Show [D]iagnostics per [L]ine"
      keymap.set("n", "<leader>dl", vim.diagnostic.open_float, opts) -- show diagnostics for line

      opts.desc = "Go to previous diagnostic"
      keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

      opts.desc = "Go to next diagnostic"
      keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

      -- See formatting.lua
      -- opts.desc = '[F]ormat'
      -- keymap.set('n', '<leader>f', vim.lsp.buf.format, opts)

      opts.desc = "Restart LSP"
      keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
    end

    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Change the Diagnostic symbols in the sign column (gutter)
    -- (not in youtube nvim video)
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    --  This function gets run when an LSP connects to a particular buffer.
    mason_lspconfig.setup_handlers({
      function(server_name)
        require("lspconfig")[server_name].setup({
          capabilities = capabilities,
          on_attach = on_attach,
          settings = servers[server_name],
          filetypes = (servers[server_name] or {}).filetypes,
        })
      end,
    })

    ---- configure svelte server
    --lspconfig["svelte"].setup({
    --        capabilities = capabilities,
    --        on_attach = function(client, bufnr)
    --                on_attach(client, bufnr)

    --                vim.api.nvim_create_autocmd("BufWritePost", {
    --                        pattern = { "*.js", "*.ts" },
    --                        callback = function(ctx)
    --                                if client.name == "svelte" then
    --                                        client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
    --                                end
    --                        end,
    --                })
    --        end,
    --})

    -- Diagnostics

    -- Command to toggle inline diagnostics
    vim.api.nvim_create_user_command("DiagnosticsToggleVirtualText", function()
      local current_value = vim.diagnostic.config().virtual_text
      if current_value then
        vim.diagnostic.config({ virtual_text = false })
      else
        vim.diagnostic.config({ virtual_text = true })
      end
    end, {})

    -- Command to toggle diagnostics
    vim.api.nvim_create_user_command("DiagnosticsToggle", function()
      local current_value = vim.diagnostic.is_disabled()
      if current_value then
        vim.diagnostic.enable()
      else
        vim.diagnostic.disable()
      end
    end, {})
  end,
}
