return {
  {
    "github/copilot.vim",
    config = function()
      -- Set C-y to accept the suggestion
      -- vim.keymap.set("i", "<C-y>", 'copilot#Accept("\\<CR>")', {
      --   expr = true,
      --   replace_keycodes = false,
      -- })
      -- vim.g.copilot_no_tab_map = true
    end,
  },

  {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "folke/trouble.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("chatgpt").setup({
        openai_params = {
          model = "gpt-3.5-turbo",
          frequency_penalty = 0,
          presence_penalty = 0,
          max_tokens = 4000,
          temperature = 0,
          top_p = 1,
          n = 1,
        },
      })
      local wk = require("which-key")
      wk.add({
        { "<leader>A", group = "ChatGPT" },
        { "<leader>Ac", "<cmd>ChatGPT<CR>", desc = "ChatGPT" },
        { "<leader>Ae", "<cmd>ChatGPTEditWithInstruction<CR>", desc = "Edit with instruction", mode = { "n", "v" } },
        { "<leader>Ag", "<cmd>ChatGPTRun grammar_correction<CR>", desc = "Grammar Correction", mode = { "n", "v" } },
        { "<leader>At", "<cmd>ChatGPTRun translate<CR>", desc = "Translate", mode = { "n", "v" } },
        { "<leader>Ak", "<cmd>ChatGPTRun keywords<CR>", desc = "Keywords", mode = { "n", "v" } },
        { "<leader>Ad", "<cmd>ChatGPTRun docstring<CR>", desc = "Docstring", mode = { "n", "v" } },
        { "<leader>Aa", "<cmd>ChatGPTRun add_tests<CR>", desc = "Add Tests", mode = { "n", "v" } },
        { "<leader>Ao", "<cmd>ChatGPTRun optimize_code<CR>", desc = "Optimize Code", mode = { "n", "v" } },
        { "<leader>As", "<cmd>ChatGPTRun summarize<CR>", desc = "Summarize", mode = { "n", "v" } },
        { "<leader>Af", "<cmd>ChatGPTRun fix_bugs<CR>", desc = "Fix Bugs", mode = { "n", "v" } },
        { "<leader>Ax", "<cmd>ChatGPTRun explain_code<CR>", desc = "Explain Code", mode = { "n", "v" } },
        { "<leader>Ar", "<cmd>ChatGPTRun roxygen_edit<CR>", desc = "Roxygen Edit", mode = { "n", "v" } },
        {
          "<leader>Al",
          "<cmd>ChatGPTRun code_readability_analysis<CR>",
          desc = "Code Readability Analysis",
          mode = { "n", "v" },
        },
      })
    end,
  },

  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      -- "echasnovski/mini.pick", -- for file_selector provider mini.pick
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
      "stevearc/dressing.nvim", -- for input provider dressing
      -- "folke/snacks.nvim", -- for input provider snacks
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      -- "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
    opts = {
      provider = "bedrock_eu_sonnet", -- default provider to use
      providers = {
        openai = {
          endpoint = "https://api.openai.com/v1",
          model = "gpt-5", -- your desired model (or use gpt-4o, etc.)
          timeout = 60000, -- Timeout in milliseconds, increase this for reasoning models
          extra_request_body = {
            temperature = 1,
            max_completion_tokens = 20000, -- Increase this to include reasoning tokens (for reasoning models)
            reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
          },
        },
        -- EU: claude 4.5-sonnet
        bedrock_eu_sonnet = {
          __inherited_from = "bedrock",
          is_env_set = function()
            return true
          end,
          parse_api_key = function()
            return nil
          end,
          aws_profile = "bedrock",
          aws_region = "eu-central-1",
          model = "eu.anthropic.claude-sonnet-4-5-20250929-v1:0",

          timeout = 60000, -- Timeout in milliseconds
          extra_request_body = {
            temperature = 0.75,
            -- max_tokens = 100480,
            max_tokens = 40000,
          },
        },
        -- EU: claude 4.5-haiku
        bedrock_eu_haiku = {
          __inherited_from = "bedrock",
          is_env_set = function()
            return true
          end,
          parse_api_key = function()
            return nil
          end,
          aws_profile = "bedrock",
          aws_region = "eu-central-1",
          model = "eu.anthropic.claude-haiku-4-5-20251001-v1:0",

          timeout = 60000, -- Timeout in milliseconds
          extra_request_body = {
            temperature = 0.75,
            -- max_tokens = 100480,
            max_tokens = 40000,
          },
        },
        -- US: claude 3.7-sonnet
        -- aws_region = "us-east-1",
        -- model = "us.anthropic.claude-3-7-sonnet-20250219-v1:0",
        --
        -- US: Deepseek r1
        -- aws_region = "us-east-1",
        -- model = "us.deepseek.r1-v1:0",
        --
        -- US: claude-opus-4
        -- aws_region = "us-east-1",
        -- model = "us.anthropic.claude-opus-4-1-20250805-v1:0",
      },
      behaviour = {
        auto_suggestions = false, -- Experimental stage
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        support_paste_from_clipboard = false,
        minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
        enable_token_counting = false, -- Whether to enable token counting. Default to true.
        auto_apply_diff_after_generation = true,
        -- auto_approve_tool_permissions = true, -- Auto-approve all tools (no prompts)
        auto_approve_tool_permissions = {
          -- rag_search, python, git_diff, git_commit, list_files, search_files, search_keyword, read_file_toplevel_symbols, read_file, create_file, rename_file, delete_file, create_dir, rename_dir, delete_dir, bash, web_search, fetch
          "replace_in_file",
          -- other tools:
          "rag_search",
          -- "python",
          "git_diff",
          "git_commit",
          "list_files",
          "search_files",
          "search_keyword",
          "read_file_toplevel_symbols",
          "read_file",
          "create_file",
          "rename_file",
          "delete_file",
          "create_dir",
          "rename_dir",
          "delete_dir",
          -- "bash",
          "web_search",
          "fetch",
        }, -- Auto-approve specific tools only
      },
      mappings = {
        --- @class AvanteConflictMappings
        diff = {
          ours = "co",
          theirs = "ct",
          all_theirs = "ca",
          both = "cb",
          cursor = "cc",
          next = "]x",
          prev = "[x",
        },
        suggestion = {
          accept = "<M-l>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
        jump = {
          next = "]]",
          prev = "[[",
        },
        submit = {
          normal = "<CR>",
          insert = "<C-s>",
        },
        cancel = {
          normal = { "<C-c>", "<Esc>", "q" },
          insert = { "<C-c>" },
        },
        sidebar = {
          apply_all = "A",
          apply_cursor = "a",
          retry_user_request = "r",
          edit_user_request = "e",
          switch_windows = "<Tab>",
          reverse_switch_windows = "<S-Tab>",
          remove_file = "d",
          add_file = "@",
          close = { "<Esc>", "q" },
          close_from_input = nil, -- e.g., { normal = "<Esc>", insert = "<C-d>" }
        },
      },
      hints = { enabled = true },
      windows = {
        ---@type "right" | "left" | "top" | "bottom"
        position = "right", -- the position of the sidebar
        wrap = true, -- similar to vim.o.wrap
        width = 30, -- default % based on available width
        sidebar_header = {
          enabled = true, -- true, false to enable/disable the header
          align = "center", -- left, center, right for title
          rounded = true,
        },
        input = {
          prefix = "> ",
          height = 8, -- Height of the input window in vertical layout
        },
        edit = {
          border = "rounded",
          start_insert = true, -- Start insert mode when opening the edit window
        },
        ask = {
          floating = false, -- Open the 'AvanteAsk' prompt in a floating window
          start_insert = true, -- Start insert mode when opening the ask window
          border = "rounded",
          ---@type "ours" | "theirs"
          focus_on_apply = "ours", -- which diff to focus after applying
        },
      },
      highlights = {
        ---@type AvanteConflictHighlights
        diff = {
          current = "DiffText",
          incoming = "DiffAdd",
        },
      },
      --- @class AvanteConflictUserConfig
      diff = {
        autojump = true,
        ---@type string | fun(): any
        list_opener = "copen",
        --- Override the 'timeoutlen' setting while hovering over a diff (see :help timeoutlen).
        --- Helps to avoid entering operator-pending mode with diff mappings starting with `c`.
        --- Disable by setting to -1.
        override_timeoutlen = 500,
      },
      suggestion = {
        debounce = 600,
        throttle = 600,
      },
    },
  },

  -- {
  --   "olimorris/codecompanion.nvim",
  --   opts = {},
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --     -- Optional:
  --     "ravitemer/codecompanion-history.nvim",
  --     -- "ravitemer/mcphub.nvim",
  --     { "Davidyz/VectorCode", version = "*", build = "pipx upgrade vectorcode" },
  --   },
  --   config = function()
  --     require("plugins.scripts.codecompanion")
  --   end,
  -- },
}
