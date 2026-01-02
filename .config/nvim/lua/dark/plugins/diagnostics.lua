return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "VeryLazy",
  dependencies = {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  },
  priority = 1000,
  config = function()
    require("dark.config.diagnostic")
  end,
}
