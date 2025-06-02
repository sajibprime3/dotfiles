return {
  "sajibprime3/indent-manager.nvim",
  dev = true, -- remove if using a Git repo
  config = function()
    require("indent-manager").setup({
      default_indent = 4,
      keymap_show_indent = "<leader>fis",
      keymap_open_config = "<leader>fic",
    })
  end,
}
