-- tailwind-tools.lua
return {
  "luckasRanarison/tailwind-tools.nvim",
  enabled = false,
  name = "tailwind-tools",
  build = ":UpdateRemotePlugins",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim", -- optional
    "neovim/nvim-lspconfig", -- optional
  },
  opts = {
    server = {
      settings = { -- shortcut for `settings.tailwindCSS`
        includeLanguages = {
          vue = "html",
        },
        experimental = {
          classRegex = {
            -- matches class="..."
            { 'class\\s*=\\s*"([^"]*)"' },
            -- matches :class="[...]"
            { ':class\\s*=\\s*"([^"]*)"' },
            -- matches :class="['foo', {'bar': true}]"
            { ":class\\s*=\\s*\\[([^\\]]*)\\]" },
          },
        },
        suggestion = true,
      },
    },
    conceal = {
      enabled = false,
    },
    document_color = {
      enabled = false,
    },
  }, -- your configuration
}
