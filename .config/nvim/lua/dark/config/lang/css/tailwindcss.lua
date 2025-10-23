return {
  settings = {
    tailwindCSS = {
      includeLanguages = {
        vue = "html",
      },
      experimental = {
        classRegex = {
          -- matches class="..."
          { 'class\\s*=\\s*"([^"]*)"' },
          -- matches :class="[...]"
          { ':class\\s*=\\s*"([^"]*)"' },
          -- matches :class="['foo', {'bar': true}]"
          { ":class\\s*=\\s*\\[([^\\]]*)\\]" },
        },
      },
      suggestion = true,
    },
  },
}
