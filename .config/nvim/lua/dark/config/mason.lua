require("mason").setup()
require("mason-tool-installer").setup({
  ensure_installed = {
    -- 'clangd',
    -- 'gopls',
    -- 'pyright',
    -- 'rust_analyzer',
    -- 'ts_ls',
    "lua_ls",
    "jdtls",
    "kotlin_language_server",
    "tailwindcss",
    "vtsls",
    "vue_ls",
    "stylua",
  },
  integrations = {
    ["mason-lspconfig"] = true,
    -- ["mason-null-ls"] = true,
    -- ["mason-nvim-dap"] = true,
  },
})
require("mason-lspconfig").setup({
  ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
  -- automatic_installation = true,
})
