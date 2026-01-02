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
    menu = {
      auto_show = true,
      draw = {
        components = {
          kind_icon = {
            text = function(ctx)
              if vim.tbl_contains({ "Path" }, ctx.source_name) then
                local mini_icon, _ = require("mini.icons").get(ctx.item.data.type, ctx.label)
                if mini_icon then
                  return mini_icon .. ctx.icon_gap
                end
              end

              local icon = require("lspkind").symbolic(ctx.kind, { mode = "symbol" })
              return icon .. ctx.icon_gap
            end,

            -- Optionally, use the highlight groups from mini.icons
            -- You can also add the same function for `kind.highlight` if you want to
            -- keep the highlight groups in sync with the icons.
            highlight = function(ctx)
              if vim.tbl_contains({ "Path" }, ctx.source_name) then
                local mini_icon, mini_hl = require("mini.icons").get(ctx.item.data.type, ctx.label)
                if mini_icon then
                  return mini_hl
                end
              end
              return ctx.kind_hl
            end,
          },
          kind = {
            -- Optional, use highlights from mini.icons
            highlight = function(ctx)
              if vim.tbl_contains({ "Path" }, ctx.source_name) then
                local mini_icon, mini_hl = require("mini.icons").get(ctx.item.data.type, ctx.label)
                if mini_icon then
                  return mini_hl
                end
              end
              return ctx.kind_hl
            end,
          },
        },
      },
    },
  },
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },
  fuzzy = { implementation = "prefer_rust_with_warning" },
  signature = {
    enabled = true,
  },
})
