local util = require("lspconfig.util")

local bin_name = "kotlin-language-server"

--- The presence of one of these files indicates a project root directory
--
--  These are configuration files for the various build systems supported by
--  Kotlin. I am not sure whether the language server supports Ant projects,
--  but I'm keeping it here as well since Ant does support Kotlin.
local root_files = {
  "settings.gradle", -- Gradle (multi-project)
  "settings.gradle.kts", -- Gradle (multi-project)
  "build.xml", -- Ant
  "pom.xml", -- Maven
  "build.gradle", -- Gradle
  "build.gradle.kts", -- Gradle
}

return {
  -- Ensure jdtls is installed
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "kotlin-language-server" })
    end,
  },
  {
    require("lspconfig").kotlin_language_server.setup({
      cmd = { "kotlin-language-servers" },
      root_dir = function(fname)
        return util.root_pattern(unpack(root_files))(fname) or util.root_pattern(unpack(fallback_root_files))(fname)
      end,
      settings = {
        kotlin = {
          indexing = { enabled = true },
        },
      },
    }),
  },
}
