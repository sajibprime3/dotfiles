return {
  { "echasnovski/mini.nvim", version = "*" },
  { "echasnovski/mini.icons", version = "*" },
  {
    "echasnovski/mini.move",
    version = "*",
    config = function()
      require("dark.config.mini.move")
    end,
  },
  {
    "echasnovski/mini.pairs",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("dark.config.mini.pairs")
    end,
  },
  {
    "echasnovski/mini.surround",
    version = "*",
    config = function()
      require("dark.config.mini.surround")
    end,
  },
}
