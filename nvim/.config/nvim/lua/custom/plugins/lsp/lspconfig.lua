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

    local on_attach = function(client, bufnr)
      function Map(mode, lhs, rhs, opts)
        local options = { noremap = true, silent = true, buffer = bufnr }
        if opts then
          options = vim.tbl_extend("force", options, opts)
        end
        vim.keymap.set(mode, lhs, rhs, options)
      end

      if client.name == "ruff_lsp" then
        -- Disable hover in favor of Pyright
        client.server_capabilities.hoverProvider = false
      end

      -- set keybinds
      Map("n", "gR", "<cmd>Telescope lsp_references<CR>", { desc = "Show LSP references" }) -- show definition, references
      Map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" }) -- go to declaration
      Map("n", "gd", "<cmd>Telescope lsp_definitions<CR>", { desc = "Show LSP definitions" }) -- show lsp definitions
      Map("n", "gi", "<cmd>Telescope lsp_implementations<CR>", { desc = "Show LSP implementations" }) -- show lsp implementations
      Map("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", { desc = "Show LSP type definitions" }) -- show lsp type definitions

      Map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "See available code actions" }) -- see available code actions, in visual mode will apply to selection

      Map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Smart rename" }) -- smart rename

      -- Documentation

      Map("n", "K", vim.lsp.buf.hover, { desc = "Show documentation for what is under cursor" }) -- show documentation for what is under cursor
      Map("n", "L", vim.lsp.buf.signature_help, { desc = "Show signature documentation" })

      -- Symbols

      Map("n", "<leader>sD", require("telescope.builtin").lsp_document_symbols, { desc = "Document Symbols" })
      Map(
        "n",
        "<leader>sW",
        require("telescope.builtin").lsp_dynamic_workspace_symbols,
        { desc = "[W]orkspace [S]ymbols" }
      )

      -- Diagnostics

      Map("n", "<leader>Dt", ":DiagnosticsToggle<CR>", { desc = "[T]oggle [D]iagnostics" })
      Map("n", "<leader>Di", ":DiagnosticsToggleVirtualText<CR>", { desc = "[T]oggle [D]iagnostics [I]nline text" })
      Map("n", "<leader>Dd", "<cmd>Telescope diagnostics bufnr=0<CR>", { desc = "Show [D]ocument [D]iagnostics" }) -- show  diagnostics for file
      Map("n", "<leader>Dl", vim.diagnostic.open_float, { desc = "Show [D]iagnostics per [L]ine" }) -- show diagnostics for line
      Map("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" }) -- jump to previous diagnostic in buffer
      Map("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" }) -- jump to next diagnostic in buffer

      -- See formatting.lua
      -- map('n', '<leader>f', vim.lsp.buf.format, { desc = '[F]ormat' }) -- set in conform
      Map("n", "<leader>rs", ":LspRestart<CR>", { desc = "Restart LSP" }) -- mapping to restart lsp if necessary
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
