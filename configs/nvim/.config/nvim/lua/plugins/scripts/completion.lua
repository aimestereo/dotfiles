-- Set completeopt to have a better completion experience
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.shortmess:append("c")

-- nvim-cmp setup
local cmp = require("cmp")

local lspkind = require("lspkind")
lspkind.init({})

local lspkind_comparator = function(conf)
  local lsp_types = require("cmp.types").lsp
  return function(entry1, entry2)
    if entry1.source.name ~= "nvim_lsp" then
      if entry2.source.name == "nvim_lsp" then
        return false
      else
        return nil
      end
    end
    local kind1 = lsp_types.CompletionItemKind[entry1:get_kind()]
    local kind2 = lsp_types.CompletionItemKind[entry2:get_kind()]
    if kind1 == "Variable" and entry1:get_completion_item().label:match("%w*=") then
      kind1 = "Parameter"
    end
    if kind2 == "Variable" and entry2:get_completion_item().label:match("%w*=") then
      kind2 = "Parameter"
    end

    local priority1 = conf.kind_priority[kind1] or 0
    local priority2 = conf.kind_priority[kind2] or 0
    if priority1 == priority2 then
      return nil
    end
    return priority2 < priority1
  end
end

local label_comparator = function(entry1, entry2)
  return entry1.completion_item.label < entry2.completion_item.label
end

cmp.setup({
  sorting = {
    comparators = {
      lspkind_comparator({
        kind_priority = {
          Parameter = 14,
          Variable = 12,
          Field = 11,
          Property = 11,
          Constant = 10,
          Enum = 10,
          EnumMember = 10,
          Event = 10,
          Function = 10,
          Method = 10,
          Operator = 10,
          Reference = 10,
          Struct = 10,
          File = 8,
          Folder = 8,
          Class = 5,
          Color = 5,
          Module = 5,
          Keyword = 2,
          Constructor = 1,
          Interface = 1,
          Snippet = 0,
          Text = 1,
          TypeParameter = 1,
          Unit = 1,
          Value = 1,
        },
      }),
      label_comparator,
    },
  },

  mapping = {
    -- Drop presets, set only keymaps that I use
    ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete({}),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<C-y>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    }),
  },
  sources = {
    { name = "luasnip" },
    { name = "nvim_lsp" },
    { name = "path" },
    { name = "buffer" },
  },

  -- Enable luasnip to handle snippet expansion for nvim-cmp
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },

  -- Use nice icons instead of of group names
  formatting = {
    format = lspkind.cmp_format({
      mode = "symbol", -- show only symbol annotations
      maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      -- can also be a function to dynamically calculate max width such as
      -- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,

      symbol_map = {
        Copilot = "",
        -- defaults:
        Text = "󰉿",
        Method = "󰆧",
        Function = "󰊕",
        Constructor = "",
        Field = "󰜢",
        Variable = "󰀫",
        Class = "󰠱",
        Interface = "",
        Module = "",
        Property = "󰜢",
        Unit = "󰑭",
        Value = "󰎠",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "",
        Color = "󰏘",
        File = "󰈙",
        Reference = "󰈇",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "󰏿",
        Struct = "󰙅",
        Event = "",
        Operator = "󰆕",
        TypeParameter = "",
      },
      ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
      show_labelDetails = true, -- show labelDetails in menu. Disabled by default
    }),
  },
})

--
-- cmdline
--

-- Declare only keys that I actually use
-- Based on https://github.com/hrsh7th/cmp-cmdline/issues/108#issuecomment-2119224327
-- C-j/C-k cycle through completions if a character has been typed and through
-- command history if not (from https://www.reddit.com/r/neovim/comments/v5pfmy/comment/ibb61w3/)
local cmd_mapping = {
  ["<C-Space>"] = { c = cmp.mapping.complete({}) },
  ["<C-j>"] = { c = cmp.mapping.select_next_item() },
  ["<C-k>"] = { c = cmp.mapping.select_prev_item() },
  ["<C-e>"] = { c = cmp.mapping.abort() },
  ["<C-y>"] = {
    c = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    }),
  },
}
cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmd_mapping,
  sources = {
    { name = "buffer" },
  },
})
cmp.setup.cmdline(":", {
  mapping = cmd_mapping,
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})

--
-- vim-dadbod
--

cmp.setup.filetype({ "sql" }, {
  sources = {
    -- { name = "vim-dadbod-completion" },
    { name = "buffer" },
  },
})

--
-- Luasnip
--

local ls = require("luasnip")
ls.filetype_extend("python", { "django", "django-rest" })
ls.config.set_config({
  update_events = { "TextChanged", "TextChangedI" },
})

require("luasnip.loaders.from_vscode").lazy_load()
for _, ft_path in ipairs(vim.api.nvim_get_runtime_file("snippets/*.lua", true)) do
  loadfile(ft_path)()
end

vim.keymap.set({ "i", "s" }, "<c-k>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<c-j>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { silent = true })
