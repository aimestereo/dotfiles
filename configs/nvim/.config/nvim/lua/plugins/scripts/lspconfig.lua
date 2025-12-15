local on_attach = function(client, bufnr)
  function Map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true, buffer = bufnr }
    if opts then
      options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
  end

  if client.name == "ruff" then
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
  Map("n", "<leader>lh", function()
    -- not accurate for tsserver
    -- local inlay_hint_availabe = client.server_capabilities.inlayHintProvider
    -- if not inlay_hint_availabe then
    --   print("Inlay hints not available for this server")
    --   return
    -- end
    local enable = not vim.lsp.inlay_hint.is_enabled({})
    vim.lsp.inlay_hint.enable(enable)
    print("Inlay hints " .. (enable and "enabled" or "disabled"))
  end, { desc = "Show inline hints" })

  -- Symbols

  Map("n", "<leader>sD", require("telescope.builtin").lsp_document_symbols, { desc = "Document Symbols" })
  Map("n", "<leader>sW", require("telescope.builtin").lsp_dynamic_workspace_symbols, { desc = "[W]orkspace [S]ymbols" })

  -- Diagnostics

  Map("n", "<leader>Dt", ":DiagnosticsToggle<CR>", { desc = "[T]oggle [D]iagnostics" })
  Map("n", "<leader>Di", ":DiagnosticsToggleVirtualText<CR>", { desc = "[T]oggle [D]iagnostics [I]nline text" })
  Map("n", "<leader>Dd", "<cmd>Telescope diagnostics bufnr=0<CR>", { desc = "Show [D]ocument [D]iagnostics" }) -- show  diagnostics for file
  Map("n", "<leader>Dl", vim.diagnostic.open_float, { desc = "Show [D]iagnostics per [L]ine" }) -- show diagnostics for line

  -- See formatting.lua
  -- map('n', '<leader>f', vim.lsp.buf.format, { desc = '[F]ormat' }) -- set in conform
  Map("n", "<leader>rs", ":LspRestart<CR>", { desc = "Restart LSP" }) -- mapping to restart lsp if necessary
end

--
-- Mason Configuration
--

-- import mason

local mason_tool_installer = require("mason-tool-installer")
local servers = require("plugins.consts.servers")

-- enable mason and configure icons
local mason = require("mason")
mason.setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
})

local mason_lspconfig = require("mason-lspconfig")
mason_lspconfig.setup({
  -- list of servers for mason to install
  ensure_installed = vim.tbl_keys(servers),
  -- auto-install configured servers (with lspconfig)
  automatic_installation = true, -- not the same as ensure_installed
  automatic_enable = true, -- automatically enable servers after installation
})

mason_tool_installer.setup({
  ensure_installed = {
    "prettier", -- prettier formatter
    "yamlfmt", -- yaml formatter
    "stylua", -- lua formatter
    "eslint_d", -- js linter
    "ruff",
    "sql-formatter",
    "typescript-language-server",
    "tree-sitter-cli",
  },
})

--
-- LSP Configuration
--

-- import cmp-nvim-lsp plugin
local cmp_nvim_lsp = require("cmp_nvim_lsp")

-- used to enable autocompletion (assign to every lsp server config)
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Enable folding capabilities
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

-- Change the Diagnostic symbols in the sign column (gutter)
vim.diagnostic.config({
  jump = { float = true },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "󰋼",
      [vim.diagnostic.severity.HINT] = "󰠠",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.HINT] = "",
      [vim.diagnostic.severity.INFO] = "",
    },
  },
})

-- For each LSP provide its configuration
for server_name, _ in pairs(servers) do
  -- Check if the server is configured
  if vim.lsp.config[server_name] then
    -- Set up the server with the common capabilities and on_attach function
    vim.lsp.config(server_name, {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    })
  else
    print("LSP server '" .. server_name .. "' is not configured in lspconfig.")
  end
end

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
  local is_diagnostic_enabled = vim.diagnostic.is_enabled()
  if is_diagnostic_enabled then
    vim.diagnostic.enable(false)
  else
    vim.diagnostic.enable(true)
  end
end, {})
