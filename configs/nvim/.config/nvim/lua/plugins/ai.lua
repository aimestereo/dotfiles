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
        { "<leader>a", group = "ChatGPT" },
        { "<leader>ac", "<cmd>ChatGPT<CR>", desc = "ChatGPT" },
        { "<leader>ae", "<cmd>ChatGPTEditWithInstruction<CR>", desc = "Edit with instruction", mode = { "n", "v" } },
        { "<leader>ag", "<cmd>ChatGPTRun grammar_correction<CR>", desc = "Grammar Correction", mode = { "n", "v" } },
        { "<leader>at", "<cmd>ChatGPTRun translate<CR>", desc = "Translate", mode = { "n", "v" } },
        { "<leader>ak", "<cmd>ChatGPTRun keywords<CR>", desc = "Keywords", mode = { "n", "v" } },
        { "<leader>ad", "<cmd>ChatGPTRun docstring<CR>", desc = "Docstring", mode = { "n", "v" } },
        { "<leader>aa", "<cmd>ChatGPTRun add_tests<CR>", desc = "Add Tests", mode = { "n", "v" } },
        { "<leader>ao", "<cmd>ChatGPTRun optimize_code<CR>", desc = "Optimize Code", mode = { "n", "v" } },
        { "<leader>as", "<cmd>ChatGPTRun summarize<CR>", desc = "Summarize", mode = { "n", "v" } },
        { "<leader>af", "<cmd>ChatGPTRun fix_bugs<CR>", desc = "Fix Bugs", mode = { "n", "v" } },
        { "<leader>ax", "<cmd>ChatGPTRun explain_code<CR>", desc = "Explain Code", mode = { "n", "v" } },
        { "<leader>ar", "<cmd>ChatGPTRun roxygen_edit<CR>", desc = "Roxygen Edit", mode = { "n", "v" } },
        {
          "<leader>al",
          "<cmd>ChatGPTRun code_readability_analysis<CR>",
          desc = "Code Readability Analysis",
          mode = { "n", "v" },
        },
      })
    end,
  },
  {
    "David-Kunz/gen.nvim",
    config = function()
      require("gen").setup({
        model = "mistral", -- The default model to use.
        host = "127.0.0.1", -- The host running the Ollama service.
        port = "11434", -- The port on which the Ollama service is listening.
        display_mode = "split", -- The display mode. Can be "float" or "split".
        show_prompt = true, -- Shows the Prompt submitted to Ollama.
        show_model = true, -- Displays which model you are using at the beginning of your chat session.
        no_auto_close = false, -- Never closes the window automatically.
        debug = false, -- Prints errors and the command which is run.
      })

      Map({ "n", "v" }, "<leader>om", require("gen").select_model)
      Map({ "n", "v" }, "<leader>oo", ":Gen<CR>")

      require("gen").prompts["Devops"] = {
        prompt = "You are a senior devops engineer, acting as an assistant. You offer help with cloud technologies like: Terraform, AWS, kubernetes, python. You answer with code examples when possible. $input:\n$text",
        replace = true,
      }
    end,
  },
}
