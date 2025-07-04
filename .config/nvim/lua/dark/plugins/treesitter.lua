return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {},
    -- branch = "main",
    branch = "master",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("dark.treesitter")
    end,
  },
}
