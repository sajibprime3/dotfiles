return {
  "saghen/blink.cmp",
  dependencies = { "rafamadriz/friendly-snippets" },
  version = "1.*",
  config = function()
    require("dark.config.completion")
  end,
  opts_extend = { "sources.default" },
}
