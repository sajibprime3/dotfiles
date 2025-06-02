return {
  name = "gradle(w) run",
  builder = function()
    return {
      cmd = { "./gradlew run" },
      args = {},
      components = { { "on_output_quickfix", open = true }, "default" },
    }
  end,
  condition = {
    filetype = { ".java" },
  },
}
