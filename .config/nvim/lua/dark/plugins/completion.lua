return {
  "saghen/blink.cmp",
  dependencies = {
    "rafamadriz/friendly-snippets",
    "onsails/lspkind.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  version = "1.*",
  config = function()
    require("dark.config.completion")
  end,
  opts_extend = { "sources.default" },
}
