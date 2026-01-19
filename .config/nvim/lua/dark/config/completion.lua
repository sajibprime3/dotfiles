local use_mini = false --there are some problems with mini.icons, something with `link` category not found.
local use_devicon = true

local function get_highlight(ctx)
  local hl = ctx.kind_hl
  if vim.tbl_contains({ "Path" }, ctx.source_name) then
    if use_mini then
      local mini_icon, mini_hl = require("mini.icons").get(ctx.item.data.type, ctx.label)
      if mini_icon then
        hl = mini_hl
      end
    end
    if use_devicon then
      local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
      if dev_icon then
        hl = dev_hl
      end
    end
  end
  return hl
end

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
              local icon = ctx.kind_icon
              if vim.tbl_contains({ "Path" }, ctx.source_name) then
                if use_mini then
                  local mini_icon, _ = require("mini.icons").get(ctx.item.data.type, ctx.label)
                  if mini_icon then
                    icon = mini_icon
                  end
                end
                if use_devicon then
                  local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                  if dev_icon then
                    icon = dev_icon
                  end
                end
              else
                icon = require("lspkind").symbol_map[ctx.kind] or ""
              end
              return icon .. ctx.icon_gap
            end,
            highlight = function(ctx)
              return get_highlight(ctx)
            end,
          },
          kind = {
            highlight = function(ctx)
              return get_highlight(ctx)
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
