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
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",

      { "j-hui/fidget.nvim", opts = {} },
      { "https://git.sr.ht/~whynothugo/lsp_lines.nvim" },

      -- Autoformatting
      "stevearc/conform.nvim",

      -- Completion
      "saghen/blink.cmp",
    },
    opts = {
      servers = {
        bashls = true,
        lua_ls = {},
      },
    },
    config = function(_, opts)
      -- Don't do LSP stuff if we're in Obsidian Edit mode
      if vim.g.obsidian then
        return
      end

      local lspconfig = require("lspconfig")

      local servers_to_install = vim.tbl_filter(function(key)
        local t = opts.servers[key]
        if type(t) == "table" then
          return not t.manual_install
        else
          return t
        end
      end, vim.tbl_keys(opts.servers))

      require("mason").setup()
      local ensure_installed = {
        "stylua",
        "lua_ls",
      }

      vim.list_extend(ensure_installed, servers_to_install)
      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

      for server, config in pairs(opts.servers) do
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        if config == true then
          config = {}
        end
        if pcall(require, "cmp_nvim_lsp") then
          config.capabilities = require("cmp_nvim_lsp").default_capabilities()
        end
        if pcall(require, "blink.cmp") then
          config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
        end
        config = vim.tbl_deep_extend("force", {}, {
          capabilities = capabilities,
        }, config)

        lspconfig[server].setup(config)
      end

      local disable_semantic_tokens = {
        -- lua = true,
      }

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")

          local settings = opts.servers[client.name]
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

          vim.keymap.set("n", "<space>cr", vim.lsp.buf.rename, { buffer = 0 })
          vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, { buffer = 0 })
          vim.keymap.set("n", "<space>wd", builtin.lsp_document_symbols, { buffer = 0 })

          local filetype = vim.bo[bufnr].filetype
          if disable_semantic_tokens[filetype] then
            client.server_capabilities.semanticTokensProvider = nil
          end

          -- Override server capabilities
          if settings.server_capabilities then
            for k, v in pairs(settings.server_capabilities) do
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

      require("lsp_lines").setup()
      vim.diagnostic.config({ virtual_text = true, virtual_lines = false })

      vim.keymap.set("", "<leader>l", function()
        local config = vim.diagnostic.config() or {}
        if config.virtual_text then
          vim.diagnostic.config({ virtual_text = false, virtual_lines = true })
        else
          vim.diagnostic.config({ virtual_text = true, virtual_lines = false })
        end
      end, { desc = "Toggle lsp_lines" })
    end,
  },
}
