return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
        -- used for completion, annotations and signatures of Neovim apis
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            -- Load luvit types when the `vim.uv` word is found
            { path = "luvit-meta/library", words = { "vim%.uv" } },
            { path = "/usr/share/awesome/lib/", words = { "awesome" } },
          },
        },
      },
      { "Bilal2453/luvit-meta", lazy = true },
      {
        "mason-org/mason.nvim",
        opts = {},
        dependencies = {
          "neovim/nvim-lspconfig",
          {
            "mason-org/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
          },
        },
        config = function()
          require("dark.config.mason")
        end,
      },
      { "j-hui/fidget.nvim", opts = {} },

      -- Autoformatting
      "stevearc/conform.nvim",

      -- Completion
      "saghen/blink.cmp",

      -- Lightbulb for code action.
      { "kosayoda/nvim-lightbulb" },
      -- Usage symbol like Jetbrains Idea.
      {
        "Wansmer/symbol-usage.nvim",
        event = "LspAttach", -- need run before LspAttach if you use nvim 0.9. On 0.10 use 'LspAttach'
      },

      -- Java support.
      -- "nvim-java/nvim-java",

      -- setup nvim-jdtls
      "mfussenegger/nvim-jdtls",
    },
    config = function()
      vim.lsp.config("jdtls", require("dark.config.lang.java.jdtls"))
      vim.lsp.config("lua_ls", require("dark.config.lang.lua.lua_ls"))
      vim.lsp.config("tailwindcss", require("dark.config.lang.css.tailwindcss"))
      vim.lsp.config("vtsls", require("dark.config.lang.tsjs.vtsls"))
      vim.lsp.config("vue_ls", require("dark.config.lang.vue.volar"))

      local disable_semantic_tokens = {
        -- lua = true,
      }

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")

          -- local settings = servers[client.name]
          local settings = vim.lsp._enabled_configs[client.name]
          if type(settings) ~= "table" then
            settings = {}
          end

          local builtin = require("telescope.builtin")

          vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
          vim.keymap.set("n", "gd", builtin.lsp_definitions, { buffer = 0 })
          vim.keymap.set("n", "gr", builtin.lsp_references, { buffer = 0 })
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = 0 })
          vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, { buffer = 0 })
          vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })

          vim.keymap.set("n", "<leader>c", "", { desc = "Code" })
          vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { buffer = 0, desc = "Rename" })
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = 0, desc = "Code Action" })
          vim.keymap.set("n", "<leader>wd", builtin.lsp_document_symbols, { buffer = 0 })

          local filetype = vim.bo[bufnr].filetype
          if disable_semantic_tokens[filetype] then
            client.server_capabilities.semanticTokensProvider = nil
          end

          -- Override server capabilities
          if settings.resolved_config.capabilities then
            for k, v in pairs(settings.resolved_config.capabilities) do
              if v == vim.NIL then
                ---@diagnostic disable-next-line: cast-local-type
                v = nil
              end

              client.server_capabilities[k] = v
            end
          end
        end,
      })

      require("dark.autoformat").setup()

      require("dark.config.usage-symbols")
      require("nvim-lightbulb").setup({
        autocmd = { enabled = true },
      })
    end,
  },
}
