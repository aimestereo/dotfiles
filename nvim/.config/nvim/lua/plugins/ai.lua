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
      wk.register({
        ["<leader>"] = {
          c = {
            name = "ChatGPT",
            c = { "<cmd>ChatGPT<CR>", "ChatGPT" },
            e = { "<cmd>ChatGPTEditWithInstruction<CR>", "Edit with instruction", mode = { "n", "v" } },
            g = { "<cmd>ChatGPTRun grammar_correction<CR>", "Grammar Correction", mode = { "n", "v" } },
            t = { "<cmd>ChatGPTRun translate<CR>", "Translate", mode = { "n", "v" } },
            k = { "<cmd>ChatGPTRun keywords<CR>", "Keywords", mode = { "n", "v" } },
            d = { "<cmd>ChatGPTRun docstring<CR>", "Docstring", mode = { "n", "v" } },
            a = { "<cmd>ChatGPTRun add_tests<CR>", "Add Tests", mode = { "n", "v" } },
            o = { "<cmd>ChatGPTRun optimize_code<CR>", "Optimize Code", mode = { "n", "v" } },
            s = { "<cmd>ChatGPTRun summarize<CR>", "Summarize", mode = { "n", "v" } },
            f = { "<cmd>ChatGPTRun fix_bugs<CR>", "Fix Bugs", mode = { "n", "v" } },
            x = { "<cmd>ChatGPTRun explain_code<CR>", "Explain Code", mode = { "n", "v" } },
            r = { "<cmd>ChatGPTRun roxygen_edit<CR>", "Roxygen Edit", mode = { "n", "v" } },
            l = { "<cmd>ChatGPTRun code_readability_analysis<CR>", "Code Readability Analysis", mode = { "n", "v" } },
          },
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
