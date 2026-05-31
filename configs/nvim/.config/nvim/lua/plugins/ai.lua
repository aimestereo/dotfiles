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
}
