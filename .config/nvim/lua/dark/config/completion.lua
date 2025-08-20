require("blink.cmp").setup({
  keymap = { preset = "default" },
  appearance = {
    nerd_font_variant = "mono",
  },
  cmdline = {
    enabled = true,
    keymap = { preset = "inherit" },
    completion = {
      menu = {
        auto_show = true,
      },
    },
  },
  completion = {
    documentation = {
      auto_show = true,
    },
    menu = {
      auto_show = true,
    },
    ghost_text = {
      enabled = true,
      show_with_menu = true,
    },
    list = {
      selection = {
        preselect = true,
        auto_insert = false,
      },
    },
  },
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },
  fuzzy = { implementation = "prefer_rust_with_warning" },
})
