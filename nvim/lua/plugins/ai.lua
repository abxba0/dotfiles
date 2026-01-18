-- =============================================================================
-- AI Assistant Plugins
-- =============================================================================
-- AI-powered coding assistants and code generation tools.

return {
  -- ---------------------------------------------------------------------------
  -- codecompanion.nvim - Multi-provider AI assistant
  -- ---------------------------------------------------------------------------
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "hrsh7th/nvim-cmp", -- Optional: For using slash commands and variables in the chat buffer
      "nvim-telescope/telescope.nvim", -- Optional: For using slash commands
      { "stevearc/dressing.nvim", opts = {} }, -- Optional: Improves the default Neovim UI
    },
    cmd = {
      "CodeCompanion",
      "CodeCompanionChat",
      "CodeCompanionActions",
      "CodeCompanionToggle",
    },
    keys = {
      { "<leader>aa", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "AI Actions" },
      { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "AI Chat Toggle" },
      { "<leader>aC", "<cmd>CodeCompanionChat<cr>", mode = { "n", "v" }, desc = "AI Chat (New)" },
      { "<leader>ap", "<cmd>CodeCompanion<cr>", mode = { "n", "v" }, desc = "AI Prompt" },
      { "<leader>ae", "<cmd>CodeCompanion /explain<cr>", mode = "v", desc = "AI Explain" },
      { "<leader>af", "<cmd>CodeCompanion /fix<cr>", mode = "v", desc = "AI Fix" },
      { "<leader>ar", "<cmd>CodeCompanion /refactor<cr>", mode = "v", desc = "AI Refactor" },
      { "<leader>at", "<cmd>CodeCompanion /tests<cr>", mode = "v", desc = "AI Generate Tests" },
      { "<leader>ad", "<cmd>CodeCompanion /docs<cr>", mode = "v", desc = "AI Generate Docs" },
    },
    opts = {
      strategies = {
        chat = {
          adapter = "anthropic",
        },
        inline = {
          adapter = "anthropic",
        },
        agent = {
          adapter = "anthropic",
        },
      },
      adapters = {
        anthropic = function()
          return require("codecompanion.adapters").extend("anthropic", {
            env = {
              api_key = "ANTHROPIC_API_KEY",
            },
            schema = {
              model = {
                default = "claude-sonnet-4-20250514",
              },
            },
          })
        end,
        openai = function()
          return require("codecompanion.adapters").extend("openai", {
            env = {
              api_key = "OPENAI_API_KEY",
            },
          })
        end,
        ollama = function()
          return require("codecompanion.adapters").extend("ollama", {
            schema = {
              model = {
                default = "llama3.1:latest",
              },
            },
          })
        end,
      },
      display = {
        action_palette = {
          width = 95,
          height = 10,
        },
        chat = {
          window = {
            layout = "vertical",
            width = 0.4,
            height = 0.6,
            relative = "editor",
          },
          intro_message = "Welcome to CodeCompanion! Press ? for help.",
          show_settings = false,
          show_token_count = true,
        },
        diff = {
          enabled = true,
          provider = "default",
        },
      },
      opts = {
        log_level = "ERROR",
        send_code = true,
        use_default_actions = true,
        use_default_prompts = true,
      },
    },
    config = function(_, opts)
      require("codecompanion").setup(opts)
    end,
  },

  -- ---------------------------------------------------------------------------
  -- avante.nvim - AI editor (like Cursor)
  -- ---------------------------------------------------------------------------
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false,
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
          },
        },
      },
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
    keys = {
      { "<leader>av", "<cmd>AvanteToggle<cr>", desc = "Avante Toggle" },
      { "<leader>aV", "<cmd>AvanteAsk<cr>", desc = "Avante Ask" },
    },
    opts = {
      provider = "claude",
      auto_suggestions_provider = "claude",
      claude = {
        endpoint = "https://api.anthropic.com",
        model = "claude-sonnet-4-20250514",
        temperature = 0,
        max_tokens = 4096,
      },
      behaviour = {
        auto_suggestions = false,
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = false,
      },
      mappings = {
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
      },
      hints = { enabled = true },
      windows = {
        position = "right",
        wrap = true,
        width = 30,
        sidebar_header = {
          align = "center",
          rounded = true,
        },
      },
      highlights = {
        diff = {
          current = "DiffText",
          incoming = "DiffAdd",
        },
      },
      diff = {
        autojump = true,
        list_opener = "copen",
      },
    },
  },

  -- ---------------------------------------------------------------------------
  -- copilot.vim - GitHub Copilot (optional)
  -- ---------------------------------------------------------------------------
  -- Uncomment if you want to use GitHub Copilot
  -- {
  --   "github/copilot.vim",
  --   event = "InsertEnter",
  --   config = function()
  --     vim.g.copilot_no_tab_map = true
  --     vim.g.copilot_assume_mapped = true
  --     vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
  --   end,
  -- },

  -- ---------------------------------------------------------------------------
  -- copilot.lua - GitHub Copilot (Lua version, optional)
  -- ---------------------------------------------------------------------------
  -- Uncomment if you prefer the Lua version of Copilot
  -- {
  --   "zbirenbaum/copilot.lua",
  --   cmd = "Copilot",
  --   event = "InsertEnter",
  --   opts = {
  --     suggestion = {
  --       enabled = true,
  --       auto_trigger = true,
  --       keymap = {
  --         accept = "<M-l>",
  --         accept_word = false,
  --         accept_line = false,
  --         next = "<M-]>",
  --         prev = "<M-[>",
  --         dismiss = "<C-]>",
  --       },
  --     },
  --     panel = { enabled = false },
  --     filetypes = {
  --       markdown = true,
  --       help = true,
  --     },
  --   },
  -- },

  -- ---------------------------------------------------------------------------
  -- gen.nvim - Local LLM integration (Ollama)
  -- ---------------------------------------------------------------------------
  {
    "David-Kunz/gen.nvim",
    cmd = "Gen",
    keys = {
      { "<leader>ao", "<cmd>Gen<cr>", mode = { "n", "v" }, desc = "AI (Ollama)" },
    },
    opts = {
      model = "llama3.1:latest",
      host = "localhost",
      port = "11434",
      quit_map = "q",
      retry_map = "<c-r>",
      init = function(options)
        pcall(io.popen, "ollama serve > /dev/null 2>&1 &")
      end,
      command = function(options)
        local body = { model = options.model, stream = true }
        return "curl --silent --no-buffer -X POST http://"
          .. options.host
          .. ":"
          .. options.port
          .. "/api/chat -d $body"
      end,
      display_mode = "float",
      show_prompt = false,
      show_model = false,
      no_auto_close = false,
      debug = false,
    },
  },

  -- ---------------------------------------------------------------------------
  -- ChatGPT.nvim - OpenAI ChatGPT integration (optional)
  -- ---------------------------------------------------------------------------
  -- Uncomment if you want to use ChatGPT
  -- {
  --   "jackMort/ChatGPT.nvim",
  --   event = "VeryLazy",
  --   dependencies = {
  --     "MunifTanjim/nui.nvim",
  --     "nvim-lua/plenary.nvim",
  --     "nvim-telescope/telescope.nvim",
  --   },
  --   keys = {
  --     { "<leader>ag", "<cmd>ChatGPT<cr>", desc = "ChatGPT" },
  --   },
  --   opts = {
  --     api_key_cmd = "echo $OPENAI_API_KEY",
  --   },
  -- },
}
